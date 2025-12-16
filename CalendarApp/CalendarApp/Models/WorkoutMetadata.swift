import Foundation

struct WorkoutMetadata: Codable {
    let workoutKey: String
    let workoutActivityType: String
    let workoutStartDate: String
    let distance: String
    let duration: String
    let maxLayer: Int
    let maxSubLayer: Int
    let avgHumidity: String
    let avgTemp: String
    let comment: String?
    let photoBefore: String?
    let photoAfter: String?
    let heartRateGraph: String?
    let activityGraph: String?
    let map: String?
    
    enum CodingKeys: String, CodingKey {
        case workoutKey
        case workoutActivityType
        case workoutStartDate
        case distance
        case duration
        case maxLayer
        case maxSubLayer
        case avgHumidity = "avg_humidity"
        case avgTemp = "avg_temp"
        case comment
        case photoBefore
        case photoAfter
        case heartRateGraph
        case activityGraph
        case map
    }
    
    var distanceInKm: Double {
        guard let distanceValue = Double(distance) else { return 0 }
        return distanceValue / 1000.0
    }
    
    var durationInMinutes: Int {
        guard let durationValue = Double(duration) else { return 0 }
        return Int(durationValue / 60.0)
    }
    
    var formattedDuration: String {
        let minutes = durationInMinutes
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        if hours > 0 {
            return "\(hours)ч \(remainingMinutes)м"
        }
        return "\(minutes)м"
    }
    
    var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: workoutStartDate)
    }
}

struct WorkoutMetadataResponse: Codable {
    let description: String
    let workouts: [String: WorkoutMetadata]
}

