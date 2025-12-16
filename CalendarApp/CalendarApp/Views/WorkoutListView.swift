import SwiftUI

struct WorkoutListView: View {
    let date: Date
    let workouts: [Workout]
    let coordinator: AppCoordinator
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(DateFormatterHelper.formatDateLong(date))
                .font(.headline)
                .padding(.horizontal)
                .padding(.vertical, 8)
            
            if workouts.isEmpty {
                Text("workout.list.no.workouts".localized())
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .frame(minHeight: 100)
            } else {
                ForEach(workouts) { workout in
                    WorkoutRowView(workout: workout) {
                        coordinator.showWorkoutDetail(workout, in: $navigationPath)
                    }
                    .padding(.horizontal)
                    Divider()
                }
            }
        }
    }
}

struct WorkoutRowView: View {
    let workout: Workout
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: WorkoutTypeHelper.icon(for: workout.workoutActivityType))
                    .font(.title2)
                    .foregroundColor(WorkoutTypeHelper.color(for: workout.workoutActivityType))
                    .frame(width: 40, height: 40)
                    .background(WorkoutTypeHelper.color(for: workout.workoutActivityType).opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.workoutActivityType)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if let date = workout.date {
                        Text(DateFormatterHelper.formatTime(date))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        WorkoutListView(
            date: Date(),
            workouts: [
                Workout(workoutKey: "1", workoutActivityType: "Walking/Running", workoutStartDate: "2025-11-25 09:30:00"),
                Workout(workoutKey: "2", workoutActivityType: "Yoga", workoutStartDate: "2025-11-25 18:00:00")
            ],
            coordinator: AppCoordinator(),
            navigationPath: .constant(NavigationPath())
        )
    }
}

