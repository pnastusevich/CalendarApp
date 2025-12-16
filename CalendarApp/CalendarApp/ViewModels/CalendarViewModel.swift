import Foundation
import Combine

final class CalendarViewModel: ObservableObject {
    @Published var currentMonth: Date = Date()
    @Published var selectedDate: Date?
    @Published var workouts: [Workout] = []
    @Published var workoutsByDate: [Date: [Workout]] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadWorkouts()
    }
    
    func loadWorkouts() {
        isLoading = true
        errorMessage = nil
        
        dataService.loadWorkouts()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] workouts in
                    self?.workouts = workouts
                    self?.organizeWorkoutsByDate()
                }
            )
            .store(in: &cancellables)
    }
    
    func organizeWorkoutsByDate() {
        let calendar = Calendar.current
        var grouped: [Date: [Workout]] = [:]
        
        for workout in workouts {
            guard let workoutDate = workout.date else {
                continue
            }
            let dayOnly = calendar.startOfDay(for: workoutDate)
            
            if grouped[dayOnly] == nil {
                grouped[dayOnly] = []
            }
            grouped[dayOnly]?.append(workout)
        }
        
        workoutsByDate = grouped
    }
    
    func workouts(for date: Date) -> [Workout] {
        let calendar = Calendar.current
        let dayOnly = calendar.startOfDay(for: date)
        
        if let workouts = workoutsByDate[dayOnly] {
            return workouts
        }
        
        for (workoutDate, workouts) in workoutsByDate {
            if calendar.isDate(workoutDate, inSameDayAs: dayOnly) {
                return workouts
            }
        }
        return []
    }
    
    func hasWorkouts(on date: Date) -> Bool {
        let calendar = Calendar.current
        let dayOnly = calendar.startOfDay(for: date)
        
        if workoutsByDate[dayOnly] != nil {
            return true
        }
        
        for (workoutDate, _) in workoutsByDate {
            if calendar.isDate(workoutDate, inSameDayAs: dayOnly) {
                return true
            }
        }
        return false
    }
    
    func selectDate(_ date: Date) {
        let calendar = Calendar.current
        let dayOnly = calendar.startOfDay(for: date)
        let dateMonth = calendar.component(.month, from: dayOnly)
        let dateYear = calendar.component(.year, from: dayOnly)
        let currentMonthValue = calendar.component(.month, from: currentMonth)
        let currentYear = calendar.component(.year, from: currentMonth)
        
        if dateMonth != currentMonthValue || dateYear != currentYear {
            if let newMonth = calendar.date(from: DateComponents(year: dateYear, month: dateMonth)) {
                currentMonth = newMonth
            }
        }
        
        selectedDate = dayOnly
    }
    
    func goToPreviousMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    func goToNextMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    func goToToday() {
        currentMonth = Date()
        selectedDate = Calendar.current.startOfDay(for: Date())
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: currentMonth).capitalized
    }
    
    var weekdays: [String] {
        [
            "weekday.mon".localized(),
            "weekday.tue".localized(),
            "weekday.wed".localized(),
            "weekday.thu".localized(),
            "weekday.fri".localized(),
            "weekday.sat".localized(),
            "weekday.sun".localized()
        ]
    }
    
    var calendarDays: [CalendarDay] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!.count
        
        var days: [CalendarDay] = []
        
        let daysToSubtract = (firstWeekday - calendar.firstWeekday + 7) % 7
        if daysToSubtract > 0 {
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
            let daysInPreviousMonth = calendar.range(of: .day, in: .month, for: previousMonth)!.count
            for i in (daysInPreviousMonth - daysToSubtract + 1)...daysInPreviousMonth {
                if let date = calendar.date(byAdding: .day, value: i - daysInPreviousMonth, to: startOfMonth) {
                    days.append(CalendarDay(date: date, isCurrentMonth: false))
                }
            }
        }
        
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                let isToday = calendar.isDateInToday(date)
                let hasWorkouts = hasWorkouts(on: date)
                let isSelected = selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!)
                days.append(CalendarDay(
                    date: date,
                    isCurrentMonth: true,
                    isToday: isToday,
                    hasWorkouts: hasWorkouts,
                    isSelected: isSelected
                ))
            }
        }
        
        let remainingDays = 42 - days.count
        if remainingDays > 0 {
            for i in 1...remainingDays {
                if let date = calendar.date(byAdding: .day, value: daysInMonth + i - 1, to: startOfMonth) {
                    days.append(CalendarDay(date: date, isCurrentMonth: false))
                }
            }
        }
        
        return days
    }
}

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let isCurrentMonth: Bool
    let isToday: Bool
    let hasWorkouts: Bool
    let isSelected: Bool
    
    init(date: Date, isCurrentMonth: Bool = true, isToday: Bool = false, hasWorkouts: Bool = false, isSelected: Bool = false) {
        self.date = date
        self.isCurrentMonth = isCurrentMonth
        self.isToday = isToday
        self.hasWorkouts = hasWorkouts
        self.isSelected = isSelected
    }
    
    var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }
}

