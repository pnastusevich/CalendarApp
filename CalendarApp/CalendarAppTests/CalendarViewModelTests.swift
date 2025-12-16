import XCTest
import Combine
@testable import CalendarApp

final class CalendarViewModelTests: XCTestCase {
    
    var viewModel: CalendarViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testOrganizeWorkoutsByDate() {
        let calendar = Calendar.current
        let testDate1 = calendar.date(from: DateComponents(year: 2025, month: 11, day: 25, hour: 9, minute: 30))!
        let testDate2 = calendar.date(from: DateComponents(year: 2025, month: 11, day: 24, hour: 14, minute: 0))!
        
        let workouts = [
            Workout(workoutKey: "1", workoutActivityType: "Walking/Running", workoutStartDate: "2025-11-25 09:30:00"),
            Workout(workoutKey: "2", workoutActivityType: "Yoga", workoutStartDate: "2025-11-25 18:00:00"),
            Workout(workoutKey: "3", workoutActivityType: "Cycling", workoutStartDate: "2025-11-24 14:00:00")
        ]
        
        viewModel = CalendarViewModel()
        viewModel.workouts = workouts
        viewModel.organizeWorkoutsByDate()
        
        let dayOnly1 = calendar.startOfDay(for: testDate1)
        let dayOnly2 = calendar.startOfDay(for: testDate2)
        
        XCTAssertEqual(viewModel.workoutsByDate[dayOnly1]?.count ?? 0, 2, "Should have 2 workouts on Nov 25")
        XCTAssertEqual(viewModel.workoutsByDate[dayOnly2]?.count ?? 0, 1, "Should have 1 workout on Nov 24")
    }
    
    func testWorkoutsForDate() {
        let calendar = Calendar.current
        let testDate = calendar.date(from: DateComponents(year: 2025, month: 11, day: 25, hour: 15, minute: 0))!
        
        let workouts = [
            Workout(workoutKey: "1", workoutActivityType: "Walking/Running", workoutStartDate: "2025-11-25 09:30:00"),
            Workout(workoutKey: "2", workoutActivityType: "Yoga", workoutStartDate: "2025-11-25 18:00:00")
        ]
        
        viewModel = CalendarViewModel()
        viewModel.workouts = workouts
        viewModel.organizeWorkoutsByDate()
        
        let workoutsForDate = viewModel.workouts(for: testDate)
        XCTAssertEqual(workoutsForDate.count, 2, "Should return 2 workouts for Nov 25")
    }
    
    func testHasWorkoutsOnDate() {
        let calendar = Calendar.current
        let testDateWithWorkouts = calendar.date(from: DateComponents(year: 2025, month: 11, day: 25, hour: 12, minute: 0))!
        let testDateWithoutWorkouts = calendar.date(from: DateComponents(year: 2025, month: 11, day: 20, hour: 12, minute: 0))!
        
        let workouts = [
            Workout(workoutKey: "1", workoutActivityType: "Walking/Running", workoutStartDate: "2025-11-25 09:30:00")
        ]
        
        viewModel = CalendarViewModel()
        viewModel.workouts = workouts
        viewModel.organizeWorkoutsByDate()
        
        XCTAssertTrue(viewModel.hasWorkouts(on: testDateWithWorkouts), "Should have workouts on Nov 25")
        XCTAssertFalse(viewModel.hasWorkouts(on: testDateWithoutWorkouts), "Should not have workouts on Nov 20")
    }
    
    func testSelectDate() {
        let calendar = Calendar.current
        let testDate = calendar.date(from: DateComponents(year: 2025, month: 11, day: 25, hour: 15, minute: 0))!
        
        viewModel = CalendarViewModel()
        viewModel.currentMonth = calendar.date(from: DateComponents(year: 2025, month: 10))!
        
        viewModel.selectDate(testDate)
        
        XCTAssertNotNil(viewModel.selectedDate, "Selected date should not be nil")
        XCTAssertEqual(calendar.component(.month, from: viewModel.currentMonth), 11, "Should switch to November")
        XCTAssertEqual(calendar.component(.year, from: viewModel.currentMonth), 2025, "Should be year 2025")
    }
    
    func testGoToPreviousMonth() {
        let calendar = Calendar.current
        let initialMonth = calendar.date(from: DateComponents(year: 2025, month: 11))!
        
        viewModel = CalendarViewModel()
        viewModel.currentMonth = initialMonth
        
        viewModel.goToPreviousMonth()
        
        let newMonth = calendar.component(.month, from: viewModel.currentMonth)
        XCTAssertEqual(newMonth, 10, "Should go to October")
    }
    
    func testGoToNextMonth() {
        let calendar = Calendar.current
        let initialMonth = calendar.date(from: DateComponents(year: 2025, month: 11))!
        
        viewModel = CalendarViewModel()
        viewModel.currentMonth = initialMonth
        
        viewModel.goToNextMonth()
        
        let newMonth = calendar.component(.month, from: viewModel.currentMonth)
        XCTAssertEqual(newMonth, 12, "Should go to December")
    }
    
    func testGoToToday() {
        let calendar = Calendar.current
        let pastMonth = calendar.date(from: DateComponents(year: 2024, month: 1))!
        
        viewModel = CalendarViewModel()
        viewModel.currentMonth = pastMonth
        
        viewModel.goToToday()
        
        let today = Date()
        let currentMonth = calendar.component(.month, from: viewModel.currentMonth)
        let todayMonth = calendar.component(.month, from: today)
        
        XCTAssertEqual(currentMonth, todayMonth, "Should go to current month")
        XCTAssertNotNil(viewModel.selectedDate, "Selected date should be set")
    }
    
    func testMonthYearString() {
        let calendar = Calendar.current
        let testMonth = calendar.date(from: DateComponents(year: 2025, month: 11))!
        
        viewModel = CalendarViewModel()
        viewModel.currentMonth = testMonth
        
        let monthYearString = viewModel.monthYearString
        XCTAssertFalse(monthYearString.isEmpty, "Month year string should not be empty")
        XCTAssertTrue(monthYearString.contains("2025") || monthYearString.contains("2025"), "Should contain year")
    }
    
    func testCalendarDays() {
        let calendar = Calendar.current
        let testMonth = calendar.date(from: DateComponents(year: 2025, month: 11))!
        
        viewModel = CalendarViewModel()
        viewModel.currentMonth = testMonth
        
        let days = viewModel.calendarDays
        
        XCTAssertGreaterThan(days.count, 0, "Should have calendar days")
        XCTAssertLessThanOrEqual(days.count, 42, "Should have at most 42 days (6 weeks)")
        
        let currentMonthDays = days.filter { $0.isCurrentMonth }
        XCTAssertEqual(currentMonthDays.count, 30, "November should have 30 days")
    }
}

