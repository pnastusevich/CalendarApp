import SwiftUI

struct WorkoutTypeHelper {
    static func icon(for type: String) -> String {
        switch type {
        case "Walking/Running":
            return "figure.run"
        case "Cycling":
            return "bicycle"
        case "Yoga":
            return "figure.yoga"
        case "Water":
            return "drop.fill"
        case "Strength":
            return "dumbbell.fill"
        default:
            return "figure.fitness"
        }
    }
    
    static func color(for type: String) -> Color {
        switch type {
        case "Walking/Running":
            return .green
        case "Cycling":
            return .blue
        case "Yoga":
            return .purple
        case "Water":
            return .cyan
        case "Strength":
            return .orange
        default:
            return .gray
        }
    }
}

