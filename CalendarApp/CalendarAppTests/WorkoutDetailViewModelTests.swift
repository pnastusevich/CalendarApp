import XCTest
import Combine
@testable import CalendarApp

final class WorkoutDetailViewModelTests: XCTestCase {
    
    var viewModel: WorkoutDetailViewModel!
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
    
    func testHeartRateData() {
        let workout = Workout(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00"
        )
        
        viewModel = WorkoutDetailViewModel(workout: workout)
        
        let diagramData = [
            DiagramDataPoint(
                timeNumeric: 0,
                heartRate: 72,
                speedKmh: 5.0,
                distanceMeters: 0,
                steps: 0,
                elevation: 45.2,
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 12.5,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:30:00"
            ),
            DiagramDataPoint(
                timeNumeric: 60,
                heartRate: 85,
                speedKmh: 6.5,
                distanceMeters: 100,
                steps: 120,
                elevation: 45.5,
                latitude: 55.7560,
                longitude: 37.6175,
                temperatureCelsius: 12.6,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:31:00"
            ),
            DiagramDataPoint(
                timeNumeric: 120,
                heartRate: 95,
                speedKmh: 7.0,
                distanceMeters: 200,
                steps: 240,
                elevation: 46.0,
                latitude: 55.7562,
                longitude: 37.6177,
                temperatureCelsius: 12.7,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:32:00"
            )
        ]
        
        viewModel.diagramData = diagramData
        
        let heartRateData = viewModel.heartRateData
        
        XCTAssertEqual(heartRateData.count, 3, "Should have 3 heart rate data points")
        XCTAssertEqual(heartRateData[0].time, 0)
        XCTAssertEqual(heartRateData[0].heartRate, 72)
        XCTAssertEqual(heartRateData[1].time, 60)
        XCTAssertEqual(heartRateData[1].heartRate, 85)
    }
    
    func testMaxHeartRate() {
        let workout = Workout(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00"
        )
        
        viewModel = WorkoutDetailViewModel(workout: workout)
        
        let diagramData = [
            DiagramDataPoint(
                timeNumeric: 0,
                heartRate: 72,
                speedKmh: 5.0,
                distanceMeters: 0,
                steps: 0,
                elevation: 45.2,
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 12.5,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:30:00"
            ),
            DiagramDataPoint(
                timeNumeric: 60,
                heartRate: 95,
                speedKmh: 6.5,
                distanceMeters: 100,
                steps: 120,
                elevation: 45.5,
                latitude: 55.7560,
                longitude: 37.6175,
                temperatureCelsius: 12.6,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:31:00"
            ),
            DiagramDataPoint(
                timeNumeric: 120,
                heartRate: 88,
                speedKmh: 7.0,
                distanceMeters: 200,
                steps: 240,
                elevation: 46.0,
                latitude: 55.7562,
                longitude: 37.6177,
                temperatureCelsius: 12.7,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:32:00"
            )
        ]
        
        viewModel.diagramData = diagramData
        
        XCTAssertEqual(viewModel.maxHeartRate, 95, "Max heart rate should be 95")
        XCTAssertEqual(viewModel.minHeartRate, 72, "Min heart rate should be 72")
        XCTAssertEqual(viewModel.avgHeartRate, 85, "Average heart rate should be 85")
    }
    
    func testSpeedData() {
        let workout = Workout(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00"
        )
        
        viewModel = WorkoutDetailViewModel(workout: workout)
        
        let diagramData = [
            DiagramDataPoint(
                timeNumeric: 0,
                heartRate: 72,
                speedKmh: 5.0,
                distanceMeters: 0,
                steps: 0,
                elevation: 45.2,
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 12.5,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:30:00"
            ),
            DiagramDataPoint(
                timeNumeric: 60,
                heartRate: 85,
                speedKmh: 6.5,
                distanceMeters: 100,
                steps: 120,
                elevation: 45.5,
                latitude: 55.7560,
                longitude: 37.6175,
                temperatureCelsius: 12.6,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:31:00"
            ),
            DiagramDataPoint(
                timeNumeric: 120,
                heartRate: 95,
                speedKmh: 7.0,
                distanceMeters: 200,
                steps: 240,
                elevation: 46.0,
                latitude: 55.7562,
                longitude: 37.6177,
                temperatureCelsius: 12.7,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:32:00"
            )
        ]
        
        viewModel.diagramData = diagramData
        
        let speedData = viewModel.speedData
        
        XCTAssertEqual(speedData.count, 3, "Should have 3 speed data points")
        XCTAssertEqual(speedData[0].time, 0)
        XCTAssertEqual(speedData[0].speed, 5.0, accuracy: 0.1)
        XCTAssertEqual(speedData[1].speed, 6.5, accuracy: 0.1)
    }
    
    func testMaxMinAvgSpeed() {
        let workout = Workout(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00"
        )
        
        viewModel = WorkoutDetailViewModel(workout: workout)
        
        let diagramData = [
            DiagramDataPoint(
                timeNumeric: 0,
                heartRate: 72,
                speedKmh: 5.0,
                distanceMeters: 0,
                steps: 0,
                elevation: 45.2,
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 12.5,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:30:00"
            ),
            DiagramDataPoint(
                timeNumeric: 60,
                heartRate: 85,
                speedKmh: 6.5,
                distanceMeters: 100,
                steps: 120,
                elevation: 45.5,
                latitude: 55.7560,
                longitude: 37.6175,
                temperatureCelsius: 12.6,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:31:00"
            ),
            DiagramDataPoint(
                timeNumeric: 120,
                heartRate: 95,
                speedKmh: 7.0,
                distanceMeters: 200,
                steps: 240,
                elevation: 46.0,
                latitude: 55.7562,
                longitude: 37.6177,
                temperatureCelsius: 12.7,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:32:00"
            )
        ]
        
        viewModel.diagramData = diagramData
        
        XCTAssertEqual(viewModel.maxSpeed, 7.0, accuracy: 0.1, "Max speed should be 7.0")
        XCTAssertEqual(viewModel.minSpeed, 5.0, accuracy: 0.1, "Min speed should be 5.0")
        XCTAssertEqual(viewModel.avgSpeed, 6.17, accuracy: 0.1, "Average speed should be approximately 6.17")
    }
    
    func testRouteCoordinates() {
        let workout = Workout(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00"
        )
        
        viewModel = WorkoutDetailViewModel(workout: workout)
        
        let diagramData = [
            DiagramDataPoint(
                timeNumeric: 0,
                heartRate: 72,
                speedKmh: 5.0,
                distanceMeters: 0,
                steps: 0,
                elevation: 45.2,
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 12.5,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:30:00"
            ),
            DiagramDataPoint(
                timeNumeric: 60,
                heartRate: 85,
                speedKmh: 6.5,
                distanceMeters: 100,
                steps: 120,
                elevation: 45.5,
                latitude: 55.7560,
                longitude: 37.6175,
                temperatureCelsius: 12.6,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: "2025-11-25 09:31:00"
            )
        ]
        
        viewModel.diagramData = diagramData
        
        let coordinates = viewModel.routeCoordinates
        
        XCTAssertEqual(coordinates.count, 2, "Should have 2 coordinates")
        XCTAssertEqual(coordinates[0].latitude, 55.7558, accuracy: 0.0001)
        XCTAssertEqual(coordinates[0].longitude, 37.6173, accuracy: 0.0001)
        XCTAssertEqual(coordinates[1].latitude, 55.7560, accuracy: 0.0001)
        XCTAssertEqual(coordinates[1].longitude, 37.6175, accuracy: 0.0001)
    }
    
    func testEmptyDiagramData() {
        let workout = Workout(
            workoutKey: "test123",
            workoutActivityType: "Walking/Running",
            workoutStartDate: "2025-11-25 09:30:00"
        )
        
        viewModel = WorkoutDetailViewModel(workout: workout)
        viewModel.diagramData = []
        
        XCTAssertEqual(viewModel.maxHeartRate, 0, "Max heart rate should be 0 for empty data")
        XCTAssertEqual(viewModel.minHeartRate, 0, "Min heart rate should be 0 for empty data")
        XCTAssertEqual(viewModel.avgHeartRate, 0, "Average heart rate should be 0 for empty data")
        XCTAssertEqual(viewModel.maxSpeed, 0, "Max speed should be 0 for empty data")
        XCTAssertEqual(viewModel.minSpeed, 0, "Min speed should be 0 for empty data")
        XCTAssertEqual(viewModel.avgSpeed, 0, "Average speed should be 0 for empty data")
        XCTAssertEqual(viewModel.routeCoordinates.count, 0, "Route coordinates should be empty")
    }
}

