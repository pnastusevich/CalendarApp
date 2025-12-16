import SwiftUI

struct WorkoutHeaderView: View {
    let workoutType: String
    let formattedDate: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: WorkoutTypeHelper.icon(for: workoutType))
                    .font(.largeTitle)
                    .foregroundColor(WorkoutTypeHelper.color(for: workoutType))
                
                Text(workoutType)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            if let formattedDate = formattedDate {
                Text(formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

