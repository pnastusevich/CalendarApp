import XCTest
import SwiftUI
@testable import CalendarApp

final class ThemeOptionTests: XCTestCase {
    
    func testThemeOptionFromColorScheme() {
        XCTAssertEqual(ThemeOption.from(colorScheme: nil), .system)
        XCTAssertEqual(ThemeOption.from(colorScheme: .light), .light)
        XCTAssertEqual(ThemeOption.from(colorScheme: .dark), .dark)
    }
    
    func testThemeOptionColorScheme() {
        XCTAssertNil(ThemeOption.system.colorScheme)
        XCTAssertEqual(ThemeOption.light.colorScheme, .light)
        XCTAssertEqual(ThemeOption.dark.colorScheme, .dark)
    }
    
    func testThemeOptionAllCases() {
        let allCases = ThemeOption.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.system))
        XCTAssertTrue(allCases.contains(.light))
        XCTAssertTrue(allCases.contains(.dark))
    }
    
    func testThemeOptionLocalizedTitle() {
        let systemTitle = ThemeOption.system.localizedTitle
        let lightTitle = ThemeOption.light.localizedTitle
        let darkTitle = ThemeOption.dark.localizedTitle
        
        XCTAssertFalse(systemTitle.isEmpty)
        XCTAssertFalse(lightTitle.isEmpty)
        XCTAssertFalse(darkTitle.isEmpty)
    }
}

