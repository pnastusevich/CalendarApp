import XCTest
@testable import CalendarApp

final class UserDefaultsServiceTests: XCTestCase {
    var userDefaults: UserDefaults!
    var service: UserDefaultsService!
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "test_user_defaults") ?? UserDefaults.standard
        userDefaults.removePersistentDomain(forName: "test_user_defaults")
        service = UserDefaultsService(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "test_user_defaults")
        userDefaults = nil
        service = nil
        super.tearDown()
    }
    
    func testSetAndGetString() {
        let key = "test_string_key"
        let value = "test_value"
        
        service.setString(value, for: key)
        let retrieved = service.getString(for: key)
        
        XCTAssertEqual(retrieved, value, "Should retrieve the same string value")
    }
    
    func testGetStringWhenNotSet() {
        let key = "non_existent_key"
        let retrieved = service.getString(for: key)
        
        XCTAssertNil(retrieved, "Should return nil for non-existent key")
    }
    
    func testSetAndGetData() {
        let key = "test_data_key"
        let value = "test_data".data(using: .utf8)!
        
        service.setData(value, for: key)
        let retrieved = service.getData(for: key)
        
        XCTAssertEqual(retrieved, value, "Should retrieve the same data value")
    }
    
    func testGetDataWhenNotSet() {
        let key = "non_existent_data_key"
        let retrieved = service.getData(for: key)
        
        XCTAssertNil(retrieved, "Should return nil for non-existent key")
    }
    
    func testRemoveObject() {
        let key = "test_remove_key"
        let value = "test_value"
        
        service.setString(value, for: key)
        XCTAssertNotNil(service.getString(for: key), "Value should exist before removal")
        
        service.removeObject(for: key)
        XCTAssertNil(service.getString(for: key), "Value should be nil after removal")
    }
    
    func testMultipleKeys() {
        let key1 = "key1"
        let key2 = "key2"
        let value1 = "value1"
        let value2 = "value2"
        
        service.setString(value1, for: key1)
        service.setString(value2, for: key2)
        
        XCTAssertEqual(service.getString(for: key1), value1)
        XCTAssertEqual(service.getString(for: key2), value2)
    }
}

