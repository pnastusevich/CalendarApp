import Foundation
import Combine

final class DataService {
    static let shared = DataService()
    
    private init() {}
    
    func loadWorkouts() -> AnyPublisher<[Workout], Error> {
        return loadJSON(fileName: "list_workouts")
            .decode(type: WorkoutListResponse.self, decoder: JSONDecoder())
            .map { response in
                print("✅ Загружено тренировок из JSON: \(response.data.count)")
                return response.data
            }
            .eraseToAnyPublisher()
    }
    
    func loadMetadata() -> AnyPublisher<[String: WorkoutMetadata], Error> {
        return loadJSON(fileName: "metadata")
            .decode(type: WorkoutMetadataResponse.self, decoder: JSONDecoder())
            .map { $0.workouts }
            .eraseToAnyPublisher()
    }
    
    func loadDiagramData() -> AnyPublisher<[String: WorkoutDiagramData], Error> {
        return loadJSON(fileName: "diagram_data")
            .decode(type: DiagramDataResponse.self, decoder: JSONDecoder())
            .map { $0.workouts }
            .eraseToAnyPublisher()
    }
    
    func getDiagramData(for workoutKey: String) -> AnyPublisher<[DiagramDataPoint], Error> {
        return loadDiagramData()
            .map { workouts in
                workouts[workoutKey]?.data ?? []
            }
            .eraseToAnyPublisher()
    }
    
    private func loadJSON(fileName: String) -> AnyPublisher<Data, Error> {
        return Future { promise in
            var url: URL?
            
            if let dataUrl = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: "Data") {
                url = dataUrl
            } else if let directUrl = Bundle.main.url(forResource: fileName, withExtension: "json") {
                url = directUrl
            } else if let bundlePath = Bundle.main.resourcePath {
                let filePath = (bundlePath as NSString).appendingPathComponent("Data/\(fileName).json")
                if FileManager.default.fileExists(atPath: filePath) {
                    url = URL(fileURLWithPath: filePath)
                }
            }
            
            guard let fileUrl = url else {
                promise(.failure(DataServiceError.fileNotFound))
                return
            }
            
            do {
                let data = try Data(contentsOf: fileUrl)
                promise(.success(data))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

enum DataServiceError: Error {
    case fileNotFound
    case decodingError
}

