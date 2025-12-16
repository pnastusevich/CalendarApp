import Foundation
import Photos
@testable import CalendarApp

class MockPhotoLibraryService: PhotoLibraryServiceProtocol {
    var authorizationStatus: PHAuthorizationStatus
    var requestAuthorizationCalled = false
    var requestAuthorizationCompletion: ((PHAuthorizationStatus) -> Void)?
    
    init(authorizationStatus: PHAuthorizationStatus = .notDetermined) {
        self.authorizationStatus = authorizationStatus
    }
    
    func requestAuthorization(completion: @escaping (PHAuthorizationStatus) -> Void) {
        requestAuthorizationCalled = true
        requestAuthorizationCompletion = completion
        completion(authorizationStatus)
    }
}

