import SwiftUI

struct WorkoutCommentView: View {
    let comment: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("workout.detail.comment".localized())
                .font(.headline)
            
            Text(comment)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

