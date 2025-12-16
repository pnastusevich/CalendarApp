import SwiftUI
import PhotosUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        handlePhotoButtonTap()
                    }) {
                        Group {
                            if let profileImage = viewModel.profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    }
                    .photosPicker(
                        isPresented: $viewModel.showPhotosPicker,
                        selection: $viewModel.selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    )
                    .onChange(of: viewModel.selectedPhoto) { newValue in
                        viewModel.loadPhoto(from: newValue)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            
            Section(header: Text("profile.personal.info".localized())) {
                TextField("profile.name".localized(), text: $viewModel.name)
                    .onChange(of: viewModel.name) { _ in
                        viewModel.saveProfile()
                    }
                
                TextField("profile.email".localized(), text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onChange(of: viewModel.email) { _ in
                        viewModel.saveProfile()
                    }
                
                TextField("profile.phone".localized(), text: $viewModel.phoneNumber)
                    .keyboardType(.phonePad)
                    .onChange(of: viewModel.phoneNumber) { _ in
                        viewModel.saveProfile()
                    }
                
                DatePicker(
                    "profile.date.of.birth".localized(),
                    selection: $viewModel.dateOfBirth,
                    displayedComponents: .date
                )
                .onChange(of: viewModel.dateOfBirth) { _ in
                    viewModel.saveProfile()
                }
            }
            
            Section(header: Text("profile.appearance".localized())) {
                Picker("profile.theme".localized(), selection: Binding(
                    get: {
                        viewModel.themeOption
                    },
                    set: { newValue in
                        viewModel.setThemeOption(newValue)
                    }
                )) {
                    ForEach(ThemeOption.allCases, id: \.self) { option in
                        Text(option.localizedTitle).tag(option)
                    }
                }
            }
        }
        .navigationTitle("profile.title".localized())
        .alert("profile.photo.permission.title".localized(), isPresented: $viewModel.showPermissionAlert) {
            Button("profile.photo.permission.settings".localized()) {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("profile.photo.permission.cancel".localized(), role: .cancel) {}
        } message: {
            Text("profile.photo.permission.message".localized())
        }
    }
    
    private func handlePhotoButtonTap() {
        switch viewModel.photoAuthorizationStatus {
        case .authorized, .limited:
            viewModel.showPhotosPicker = true
        case .notDetermined:
            viewModel.requestPhotoAccess()
        case .denied, .restricted:
            viewModel.showPermissionAlert = true
        @unknown default:
            viewModel.showPermissionAlert = true
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}

