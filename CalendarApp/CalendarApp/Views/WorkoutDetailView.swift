import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @StateObject private var viewModel: WorkoutDetailViewModel
    let coordinator: AppCoordinator
    
    init(workout: Workout, coordinator: AppCoordinator) {
        self.workout = workout
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: WorkoutDetailViewModel(workout: workout))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else if viewModel.metadata != nil {
                    WorkoutHeaderView(
                        workoutType: workout.workoutActivityType,
                        formattedDate: viewModel.formattedDate
                    )
                    
                    Divider()
                    
                    WorkoutStatisticsView(
                        distance: viewModel.formattedDistance,
                        duration: viewModel.metadata?.formattedDuration ?? "",
                        temperature: viewModel.formattedTemperature,
                        humidity: viewModel.formattedHumidity
                    )
                    
                    if !viewModel.diagramData.isEmpty {
                        VStack(alignment: .leading, spacing: 20) {
                            HeartRateChartView(
                                data: viewModel.heartRateData,
                                maxHeartRate: viewModel.formattedMaxHeartRate,
                                minHeartRate: viewModel.formattedMinHeartRate,
                                avgHeartRate: viewModel.formattedAvgHeartRate
                            )
                            
                            SpeedChartView(
                                data: viewModel.speedData,
                                maxSpeed: viewModel.formattedMaxSpeed,
                                minSpeed: viewModel.formattedMinSpeed,
                                avgSpeed: viewModel.formattedAvgSpeed
                            )
                            
                            if !viewModel.routeCoordinates.isEmpty {
                                WorkoutMapView(routeCoordinates: viewModel.routeCoordinates)
                            }
                        }
                    }
                    
                    if let comment = viewModel.metadata?.comment, !comment.isEmpty {
                        WorkoutCommentView(comment: comment)
                    }
                } else if let error = viewModel.errorMessage {
                    Text(String(format: "workout.detail.error".localized(), error))
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("workout.detail.title".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WorkoutDetailView(
            workout: Workout(workoutKey: "1", workoutActivityType: "Walking/Running", workoutStartDate: "2025-11-25 09:30:00"),
            coordinator: AppCoordinator()
        )
    }
}

