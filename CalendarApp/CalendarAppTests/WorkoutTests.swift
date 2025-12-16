import XCTest
@testable import CalendarApp

final class WorkoutTests: XCTestCase {
    
    func testWorkoutDateParsing() {
        let workout = Workout(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00"
        )
        
        XCTAssertNotNil(workout.date, "Date should be parsed successfully")
        XCTAssertNotNil(workout.dayOnly, "Day only should be extracted")
        
        let calendar = Calendar.current
        if let date = workout.date {
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            XCTAssertEqual(components.year, 2025)
            XCTAssertEqual(components.month, 11)
            XCTAssertEqual(components.day, 25)
            XCTAssertEqual(components.hour, 9)
            XCTAssertEqual(components.minute, 30)
        }
    }
    
    func testWorkoutDayOnly() {
        let workout = Workout(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 14:45:00"
        )
        
        guard let dayOnly = workout.dayOnly else {
            XCTFail("dayOnly should not be nil")
            return
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dayOnly)
        XCTAssertEqual(components.year, 2025)
        XCTAssertEqual(components.month, 11)
        XCTAssertEqual(components.day, 25)
        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.minute, 0)
    }
    
    func testWorkoutEquality() {
        let workout1 = Workout(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00"
        )
        
        let workout2 = Workout(
            workoutKey: "test123",
            workoutActivityType: "Cycling",
            workoutStartDate: "2025-11-25 10:00:00"
        )
        
        let workout3 = Workout(
            workoutKey: "test456",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00"
        )
        
        XCTAssertEqual(workout1, workout2, "Workouts with same workoutKey should be equal")
        XCTAssertNotEqual(workout1, workout3, "Workouts with different workoutKey should not be equal")
    }
    
    func testWorkoutInvalidDate() {
        let workout = Workout(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "invalid-date"
        )
        
        XCTAssertNil(workout.date, "Invalid date string should return nil")
        XCTAssertNil(workout.dayOnly, "dayOnly should be nil when date is nil")
    }
}

