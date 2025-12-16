import Foundation
import Photos

protocol PhotoLibraryServiceProtocol {
    var authorizationStatus: PHAuthorizationStatus { get }
    func requestAuthorization(completion: @escaping (PHAuthorizationStatus) -> Void)
}

final class PhotoLibraryService: PhotoLibraryServiceProtocol {
    static let shared = PhotoLibraryService()
    
    private init() {}
    
    var authorizationStatus: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestAuthorization(completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                completion(status)
            }
        }
    }
}

