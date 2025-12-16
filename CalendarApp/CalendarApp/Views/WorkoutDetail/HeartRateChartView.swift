import SwiftUI
import Charts

struct HeartRateChartView: View {
    let data: [(time: Double, heartRate: Int)]
    let maxHeartRate: String
    let minHeartRate: String
    let avgHeartRate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("workout.detail.heart.rate.chart".localized())
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(maxHeartRate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(minHeartRate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(avgHeartRate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                Chart {
                    ForEach(data, id: \.time) { point in
                        LineMark(
                            x: .value("Время", point.time),
                            y: .value("Пульс", point.heartRate)
                        )
                        .foregroundStyle(.red)
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Время", point.time),
                            y: .value("Пульс", point.heartRate)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.red.opacity(0.3), .red.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: FloatingPointFormatStyle<Double>.number.precision(.fractionLength(0)))
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
                .padding([.horizontal, .bottom])
                .padding(.top, 16)
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

