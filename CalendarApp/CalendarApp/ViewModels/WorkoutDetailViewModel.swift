import Foundation
import Combine

final class WorkoutDetailViewModel: ObservableObject {
    @Published var metadata: WorkoutMetadata?
    @Published var diagramData: [DiagramDataPoint] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    let workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
        loadData()
    }
    
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        let workoutKey = workout.workoutKey
        
        let metadataPublisher = dataService.loadMetadata()
            .map { $0[workoutKey] }
            .eraseToAnyPublisher()
        
        let diagramPublisher = dataService.getDiagramData(for: workoutKey)
            .eraseToAnyPublisher()
        
        Publishers.Zip(metadataPublisher, diagramPublisher)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] metadata, diagramData in
                    self?.metadata = metadata
                    self?.diagramData = diagramData
                }
            )
            .store(in: &cancellables)
    }
    
    var heartRateData: [(time: Double, heartRate: Int)] {
        diagramData.map { ($0.timeNumeric, $0.heartRate) }
    }
    
    var maxHeartRate: Int {
        diagramData.map { $0.heartRate }.max() ?? 0
    }
    
    var minHeartRate: Int {
        diagramData.map { $0.heartRate }.min() ?? 0
    }
    
    var avgHeartRate: Int {
        guard !diagramData.isEmpty else { return 0 }
        let sum = diagramData.reduce(0) { $0 + $1.heartRate }
        return sum / diagramData.count
    }
    
    var speedData: [(time: Double, speed: Double)] {
        diagramData.map { ($0.timeNumeric, $0.speedKmh) }
    }
    
    var maxSpeed: Double {
        diagramData.map { $0.speedKmh }.max() ?? 0
    }
    
    var minSpeed: Double {
        diagramData.map { $0.speedKmh }.min() ?? 0
    }
    
    var avgSpeed: Double {
        guard !diagramData.isEmpty else { return 0 }
        let sum = diagramData.reduce(0.0) { $0 + $1.speedKmh }
        return sum / Double(diagramData.count)
    }
    
    var routeCoordinates: [(latitude: Double, longitude: Double)] {
        diagramData.map { ($0.latitude, $0.longitude) }
    }
    
    var formattedDate: String? {
        guard let date = metadata?.date else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d MMMM yyyy, HH:mm"
        return formatter.string(from: date)
    }
    
    var formattedDistance: String? {
        guard let metadata = metadata else { return nil }
        return String(format: "workout.detail.distance.km".localized(), metadata.distanceInKm)
    }
    
    var formattedTemperature: String? {
        guard let metadata = metadata else { return nil }
        return String(format: "workout.detail.temperature.celsius".localized(), metadata.avgTemp)
    }
    
    var formattedHumidity: String? {
        guard let metadata = metadata else { return nil }
        return String(format: "workout.detail.humidity.percent".localized(), metadata.avgHumidity)
    }
    
    var formattedMaxHeartRate: String {
        String(format: "workout.detail.heart.rate.max".localized(), maxHeartRate)
    }
    
    var formattedMinHeartRate: String {
        String(format: "workout.detail.heart.rate.min".localized(), minHeartRate)
    }
    
    var formattedAvgHeartRate: String {
        String(format: "workout.detail.heart.rate.avg".localized(), avgHeartRate)
    }
    
    var formattedMaxSpeed: String {
        String(format: "workout.detail.speed.max".localized(), maxSpeed)
    }
    
    var formattedMinSpeed: String {
        String(format: "workout.detail.speed.min".localized(), minSpeed)
    }
    
    var formattedAvgSpeed: String {
        String(format: "workout.detail.speed.avg".localized(), avgSpeed)
    }
}

