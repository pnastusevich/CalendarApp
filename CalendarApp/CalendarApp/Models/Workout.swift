import Foundation

struct Workout: Identifiable, Codable, Hashable {
    let id: String
    let workoutKey: String
    let workoutActivityType: String
    let workoutStartDate: String
    
    var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter.date(from: workoutStartDate)
    }
    
    var dayOnly: Date? {
        guard let date = date else { return nil }
        let calendar = Calendar.current
        return calendar.startOfDay(for: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case workoutKey
        case workoutActivityType
        case workoutStartDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        workoutKey = try container.decode(String.self, forKey: .workoutKey)
        workoutActivityType = try container.decode(String.self, forKey: .workoutActivityType)
        workoutStartDate = try container.decode(String.self, forKey: .workoutStartDate)
        id = workoutKey
    }
    
    init(workoutKey: String, workoutActivityType: String, workoutStartDate: String) {
        self.workoutKey = workoutKey
        self.workoutActivityType = workoutActivityType
        self.workoutStartDate = workoutStartDate
        self.id = workoutKey
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.id == rhs.id
    }
}

struct WorkoutListResponse: Codable {
    let description: String
    let data: [Workout]
}

