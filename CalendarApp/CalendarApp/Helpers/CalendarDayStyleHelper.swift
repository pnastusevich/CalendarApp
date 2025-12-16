import SwiftUI

struct CalendarDayStyleHelper {
    static func foregroundColor(for day: CalendarDay) -> Color {
        if !day.isCurrentMonth {
            return .secondary.opacity(0.5)
        } else if day.isSelected {
            return .white
        } else if day.isToday {
            return .blue
        } else {
            return .primary
        }
    }
    
    static func backgroundColor(for day: CalendarDay) -> Color {
        if day.isSelected {
            return .blue
        } else if day.isToday {
            return .blue.opacity(0.1)
        } else {
            return Color.clear
        }
    }
    
    static func workoutIndicatorColor(for day: CalendarDay) -> Color {
        if day.isSelected {
            return .white
        } else {
            return .blue
        }
    }
}

