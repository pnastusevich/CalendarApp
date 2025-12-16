import Foundation

struct DiagramDataPoint: Codable, Identifiable {
    let id = UUID()
    let timeNumeric: Double
    let heartRate: Int
    let speedKmh: Double
    let distanceMeters: Double
    let steps: Int
    let elevation: Double
    let latitude: Double
    let longitude: Double
    let temperatureCelsius: Double
    let currentLayer: Int
    let currentSubLayer: Int
    let currentTimestamp: String
    
    enum CodingKeys: String, CodingKey {
        case timeNumeric = "time_numeric"
        case heartRate
        case speedKmh = "speed_kmh"
        case distanceMeters
        case steps
        case elevation
        case latitude
        case longitude
        case temperatureCelsius
        case currentLayer
        case currentSubLayer
        case currentTimestamp
    }
    
    init(
        timeNumeric: Double,
        heartRate: Int,
        speedKmh: Double,
        distanceMeters: Double,
        steps: Int,
        elevation: Double,
        latitude: Double,
        longitude: Double,
        temperatureCelsius: Double,
        currentLayer: Int,
        currentSubLayer: Int,
        currentTimestamp: String
    ) {
        self.timeNumeric = timeNumeric
        self.heartRate = heartRate
        self.speedKmh = speedKmh
        self.distanceMeters = distanceMeters
        self.steps = steps
        self.elevation = elevation
        self.latitude = latitude
        self.longitude = longitude
        self.temperatureCelsius = temperatureCelsius
        self.currentLayer = currentLayer
        self.currentSubLayer = currentSubLayer
        self.currentTimestamp = currentTimestamp
    }
}

struct DiagramData: Codable {
    let data: [DiagramDataPoint]
    let states: [String]
}

struct DiagramDataResponse: Codable {
    let description: String
    let workouts: [String: WorkoutDiagramData]
}

struct WorkoutDiagramData: Codable {
    let description: String
    let data: [DiagramDataPoint]
    let states: [String]
}

