import XCTest
import SwiftUI
import Combine
import Photos
@testable import CalendarApp

final class ProfileViewModelTests: XCTestCase {
    var testUserDefaults: UserDefaults!
    var userDefaultsService: UserDefaultsService!
    var mockPhotoLibraryService: MockPhotoLibraryService!
    var viewModel: ProfileViewModel!
    
    override func setUp() {
        super.setUp()
        let suiteName = "test_profile_\(UUID().uuidString)"
        testUserDefaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
        userDefaultsService = UserDefaultsService(userDefaults: testUserDefaults)
        mockPhotoLibraryService = MockPhotoLibraryService()
        viewModel = ProfileViewModel(
            userDefaultsService: userDefaultsService,
            photoLibraryService: mockPhotoLibraryService
        )
        clearTestData()
    }
    
    override func tearDown() {
        clearTestData()
        viewModel = nil
        mockPhotoLibraryService = nil
        userDefaultsService = nil
        testUserDefaults = nil
        super.tearDown()
    }
    
    private func clearTestData() {
        testUserDefaults.removeObject(forKey: "profile_name")
        testUserDefaults.removeObject(forKey: "profile_email")
        testUserDefaults.removeObject(forKey: "profile_phone")
        testUserDefaults.removeObject(forKey: "profile_date_of_birth")
        testUserDefaults.removeObject(forKey: "profile_image_data")
        testUserDefaults.removeObject(forKey: "app_color_scheme")
    }
    
    func testLoadProfile() {
        userDefaultsService.setString("Test Name", for: "profile_name")
        userDefaultsService.setString("test@example.com", for: "profile_email")
        userDefaultsService.setString("+1234567890", for: "profile_phone")
        
        let testDate = Date()
        if let dateData = try? JSONEncoder().encode(testDate) {
            userDefaultsService.setData(dateData, for: "profile_date_of_birth")
        }
        
        viewModel.loadProfile()
        
        XCTAssertEqual(viewModel.name, "Test Name")
        XCTAssertEqual(viewModel.email, "test@example.com")
        XCTAssertEqual(viewModel.phoneNumber, "+1234567890")
    }
    
    func testSaveProfile() {
        viewModel.name = "New Name"
        viewModel.email = "new@example.com"
        viewModel.phoneNumber = "+9876543210"
        
        viewModel.saveProfile()
        
        XCTAssertEqual(userDefaultsService.getString(for: "profile_name"), "New Name")
        XCTAssertEqual(userDefaultsService.getString(for: "profile_email"), "new@example.com")
        XCTAssertEqual(userDefaultsService.getString(for: "profile_phone"), "+9876543210")
    }
    
    func testSaveAndLoadDateOfBirth() {
        let testDate = Date(timeIntervalSince1970: 946684800)
        viewModel.dateOfBirth = testDate
        
        viewModel.saveProfile()
        
        viewModel.dateOfBirth = Date()
        viewModel.loadProfile()
        
        let calendar = Calendar.current
        let savedComponents = calendar.dateComponents([.year, .month, .day], from: viewModel.dateOfBirth)
        let testComponents = calendar.dateComponents([.year, .month, .day], from: testDate)
        
        XCTAssertEqual(savedComponents.year, testComponents.year)
        XCTAssertEqual(savedComponents.month, testComponents.month)
        XCTAssertEqual(savedComponents.day, testComponents.day)
    }
    
    func testSetColorSchemeLight() {
        viewModel.setColorScheme(.light)
        
        XCTAssertEqual(viewModel.colorScheme, .light)
        XCTAssertEqual(userDefaultsService.getString(for: "app_color_scheme"), "light")
    }
    
    func testSetColorSchemeDark() {
        viewModel.setColorScheme(.dark)
        
        XCTAssertEqual(viewModel.colorScheme, .dark)
        XCTAssertEqual(userDefaultsService.getString(for: "app_color_scheme"), "dark")
    }
    
    func testSetColorSchemeNil() {
        viewModel.setColorScheme(.light)
        viewModel.setColorScheme(nil)
        
        XCTAssertNil(viewModel.colorScheme)
        XCTAssertNil(userDefaultsService.getString(for: "app_color_scheme"))
    }
    
    func testLoadColorScheme() {
        userDefaultsService.setString("light", for: "app_color_scheme")
        viewModel.loadProfile()
        
        XCTAssertEqual(viewModel.colorScheme, .light)
        
        userDefaultsService.setString("dark", for: "app_color_scheme")
        viewModel.loadProfile()
        
        XCTAssertEqual(viewModel.colorScheme, .dark)
    }
    
    func testThemeOption() {
        viewModel.setColorScheme(.light)
        XCTAssertEqual(viewModel.themeOption, .light)
        
        viewModel.setColorScheme(.dark)
        XCTAssertEqual(viewModel.themeOption, .dark)
        
        viewModel.setColorScheme(nil)
        XCTAssertEqual(viewModel.themeOption, .system)
    }
    
    func testSetThemeOption() {
        viewModel.setThemeOption(.light)
        XCTAssertEqual(viewModel.colorScheme, .light)
        
        viewModel.setThemeOption(.dark)
        XCTAssertEqual(viewModel.colorScheme, .dark)
        
        viewModel.setThemeOption(.system)
        XCTAssertNil(viewModel.colorScheme)
    }
    
    func testPhotoAuthorizationStatus() {
        mockPhotoLibraryService.authorizationStatus = .authorized
        XCTAssertEqual(viewModel.photoAuthorizationStatus, .authorized)
        
        mockPhotoLibraryService.authorizationStatus = .denied
        XCTAssertEqual(viewModel.photoAuthorizationStatus, .denied)
    }
    
    func testRequestPhotoAccessAuthorized() {
        mockPhotoLibraryService.authorizationStatus = .authorized
        
        let expectation = XCTestExpectation(description: "Photo access requested")
        
        viewModel.requestPhotoAccess()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.showPhotosPicker, "Should show photos picker when authorized")
            XCTAssertFalse(self.viewModel.showPermissionAlert, "Should not show permission alert when authorized")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRequestPhotoAccessDenied() {
        mockPhotoLibraryService.authorizationStatus = .denied
        
        let expectation = XCTestExpectation(description: "Photo access requested")
        
        viewModel.requestPhotoAccess()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.showPhotosPicker, "Should not show photos picker when denied")
            XCTAssertTrue(self.viewModel.showPermissionAlert, "Should show permission alert when denied")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRequestPhotoAccessLimited() {
        mockPhotoLibraryService.authorizationStatus = .limited
        
        let expectation = XCTestExpectation(description: "Photo access requested")
        
        viewModel.requestPhotoAccess()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.showPhotosPicker, "Should show photos picker when limited")
            XCTAssertFalse(self.viewModel.showPermissionAlert, "Should not show permission alert when limited")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

