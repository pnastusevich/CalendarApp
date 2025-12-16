import Foundation

protocol UserDefaultsServiceProtocol {
    func getString(for key: String) -> String?
    func setString(_ value: String, for key: String)
    func getData(for key: String) -> Data?
    func setData(_ value: Data, for key: String)
    func removeObject(for key: String)
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    static let shared = UserDefaultsService()
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func getString(for key: String) -> String? {
        userDefaults.string(forKey: key)
    }
    
    func setString(_ value: String, for key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func getData(for key: String) -> Data? {
        userDefaults.data(forKey: key)
    }
    
    func setData(_ value: Data, for key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func removeObject(for key: String) {
        userDefaults.removeObject(forKey: key)
    }
}

