import SwiftUI
import Charts

struct SpeedChartView: View {
    let data: [(time: Double, speed: Double)]
    let maxSpeed: String
    let minSpeed: String
    let avgSpeed: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("workout.detail.speed.chart".localized())
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(maxSpeed)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(minSpeed)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(avgSpeed)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                Chart {
                    ForEach(data, id: \.time) { point in
                        LineMark(
                            x: .value("Время", point.time),
                            y: .value("Скорость", point.speed)
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Время", point.time),
                            y: .value("Скорость", point.speed)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .blue.opacity(0.0)],
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

