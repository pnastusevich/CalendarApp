import SwiftUI

struct WorkoutStatisticsView: View {
    let distance: String?
    let duration: String
    let temperature: String?
    let humidity: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("workout.detail.statistics".localized())
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                if let distance = distance {
                    StatCard(
                        title: "workout.detail.distance".localized(),
                        value: distance,
                        icon: "ruler"
                    )
                }
                
                StatCard(
                    title: "workout.detail.duration".localized(),
                    value: duration,
                    icon: "clock"
                )
                
                if let temperature = temperature {
                    StatCard(
                        title: "workout.detail.temperature".localized(),
                        value: temperature,
                        icon: "thermometer"
                    )
                }
                
                if let humidity = humidity {
                    StatCard(
                        title: "workout.detail.humidity".localized(),
                        value: humidity,
                        icon: "humidity"
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

