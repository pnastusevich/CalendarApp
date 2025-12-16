import Foundation
import SwiftUI
import PhotosUI
import UIKit
import Combine
import Photos

final class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var profileImage: Image?
    @Published var profileImageData: Data?
    @Published var colorScheme: ColorScheme?
    @Published var showPhotosPicker = false
    @Published var showPermissionAlert = false
    
    private let userDefaultsService: UserDefaultsServiceProtocol
    private let photoLibraryService: PhotoLibraryServiceProtocol
    
    private let nameKey = "profile_name"
    private let emailKey = "profile_email"
    private let phoneKey = "profile_phone"
    private let dateOfBirthKey = "profile_date_of_birth"
    private let profileImageKey = "profile_image_data"
    private let colorSchemeKey = "app_color_scheme"
    
    var photoAuthorizationStatus: PHAuthorizationStatus {
        photoLibraryService.authorizationStatus
    }
    
    init(
        userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService.shared,
        photoLibraryService: PhotoLibraryServiceProtocol = PhotoLibraryService.shared
    ) {
        self.userDefaultsService = userDefaultsService
        self.photoLibraryService = photoLibraryService
        loadProfile()
    }
    
    func requestPhotoAccess() {
        photoLibraryService.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .authorized, .limited:
                self.showPhotosPicker = true
            case .denied, .restricted:
                self.showPermissionAlert = true
            case .notDetermined:
                break
            @unknown default:
                self.showPermissionAlert = true
            }
        }
    }
    
    func loadProfile() {
        name = userDefaultsService.getString(for: nameKey) ?? ""
        email = userDefaultsService.getString(for: emailKey) ?? ""
        phoneNumber = userDefaultsService.getString(for: phoneKey) ?? ""
        
        if let dateData = userDefaultsService.getData(for: dateOfBirthKey),
           let date = try? JSONDecoder().decode(Date.self, from: dateData) {
            dateOfBirth = date
        }
        
        if let imageData = userDefaultsService.getData(for: profileImageKey) {
            profileImageData = imageData
            if let uiImage = UIImage(data: imageData) {
                profileImage = Image(uiImage: uiImage)
            }
        }
        
        if let schemeRaw = userDefaultsService.getString(for: colorSchemeKey) {
            switch schemeRaw {
            case "light":
                colorScheme = .light
            case "dark":
                colorScheme = .dark
            default:
                colorScheme = nil
            }
        }
    }
    
    func saveProfile() {
        userDefaultsService.setString(name, for: nameKey)
        userDefaultsService.setString(email, for: emailKey)
        userDefaultsService.setString(phoneNumber, for: phoneKey)
        
        if let dateData = try? JSONEncoder().encode(dateOfBirth) {
            userDefaultsService.setData(dateData, for: dateOfBirthKey)
        }
        
        if let imageData = profileImageData {
            userDefaultsService.setData(imageData, for: profileImageKey)
        }
    }
    
    func loadPhoto(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        
        item.loadTransferable(type: Data.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let data = data, let uiImage = UIImage(data: data) {
                        self.profileImageData = data
                        self.profileImage = Image(uiImage: uiImage)
                        self.saveProfile()
                    }
                case .failure:
                    break
                }
            }
        }
    }
    
    func setColorScheme(_ scheme: ColorScheme?) {
        colorScheme = scheme
        if let scheme = scheme {
            let schemeRaw = scheme == .light ? "light" : "dark"
            userDefaultsService.setString(schemeRaw, for: colorSchemeKey)
        } else {
            userDefaultsService.removeObject(for: colorSchemeKey)
        }
    }
    
    var themeOption: ThemeOption {
        ThemeOption.from(colorScheme: colorScheme)
    }
    
    func setThemeOption(_ option: ThemeOption) {
        setColorScheme(option.colorScheme)
    }
}

enum ThemeOption: String, CaseIterable {
    case system
    case light
    case dark
    
    var localizedTitle: String {
        switch self {
        case .system:
            return "profile.theme.system".localized()
        case .light:
            return "profile.theme.light".localized()
        case .dark:
            return "profile.theme.dark".localized()
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    static func from(colorScheme: ColorScheme?) -> ThemeOption {
        guard let colorScheme = colorScheme else {
            return .system
        }
        return colorScheme == .light ? .light : .dark
    }
}

