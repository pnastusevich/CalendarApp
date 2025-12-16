import Foundation

struct DateFormatterHelper {
    static func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func formatDateLong(_ date: Date) -> String {
        formatDate(date, format: "d MMMM yyyy")
    }
    
    static func formatTime(_ date: Date) -> String {
        formatDate(date, format: "HH:mm")
    }
}

