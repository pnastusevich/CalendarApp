import XCTest
@testable import CalendarApp

final class WorkoutMetadataTests: XCTestCase {
    
    func testDistanceInKm() {
        let metadata = WorkoutMetadata(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00",
            distance: "5230.50",
            duration: "2700.00",
            maxLayer: 2,
            maxSubLayer: 4,
            avgHumidity: "65.00",
            avgTemp: "12.50",
            comment: nil,
            photoBefore: nil,
            photoAfter: nil,
            heartRateGraph: nil,
            activityGraph: nil,
            map: nil
        )
        
        XCTAssertEqual(metadata.distanceInKm, 5.2305, accuracy: 0.0001, "Distance should be converted to kilometers")
    }
    
    func testDurationInMinutes() {
        let metadata = WorkoutMetadata(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00",
            distance: "1000",
            duration: "2700.00",
            maxLayer: 2,
            maxSubLayer: 4,
            avgHumidity: "65.00",
            avgTemp: "12.50",
            comment: nil,
            photoBefore: nil,
            photoAfter: nil,
            heartRateGraph: nil,
            activityGraph: nil,
            map: nil
        )
        
        XCTAssertEqual(metadata.durationInMinutes, 45, "Duration should be converted to minutes")
    }
    
    func testFormattedDuration() {
        let metadata1 = WorkoutMetadata(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00",
            distance: "1000",
            duration: "3600.00",
            maxLayer: 2,
            maxSubLayer: 4,
            avgHumidity: "65.00",
            avgTemp: "12.50",
            comment: nil,
            photoBefore: nil,
            photoAfter: nil,
            heartRateGraph: nil,
            activityGraph: nil,
            map: nil
        )
        
        XCTAssertEqual(metadata1.formattedDuration, "1ч 0м", "Duration should be formatted as hours and minutes")
        
        let metadata2 = WorkoutMetadata(
            workoutKey: "test456",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00",
            distance: "1000",
            duration: "1800.00",
            maxLayer: 2,
            maxSubLayer: 4,
            avgHumidity: "65.00",
            avgTemp: "12.50",
            comment: nil,
            photoBefore: nil,
            photoAfter: nil,
            heartRateGraph: nil,
            activityGraph: nil,
            map: nil
        )
        
        XCTAssertEqual(metadata2.formattedDuration, "30м", "Duration less than 1 hour should show only minutes")
    }
    
    func testDateParsing() {
        let metadata = WorkoutMetadata(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00",
            distance: "1000",
            duration: "1800.00",
            maxLayer: 2,
            maxSubLayer: 4,
            avgHumidity: "65.00",
            avgTemp: "12.50",
            comment: nil,
            photoBefore: nil,
            photoAfter: nil,
            heartRateGraph: nil,
            activityGraph: nil,
            map: nil
        )
        
        XCTAssertNotNil(metadata.date, "Date should be parsed successfully")
        
        if let date = metadata.date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            XCTAssertEqual(components.year, 2025)
            XCTAssertEqual(components.month, 11)
            XCTAssertEqual(components.day, 25)
            XCTAssertEqual(components.hour, 9)
            XCTAssertEqual(components.minute, 30)
        }
    }
}

