
import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    let coordinator: AppCoordinator
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { viewModel.goToPreviousMonth() }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text(viewModel.monthYearString)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Button("calendar.today".localized()) {
                                viewModel.goToToday()
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        Button(action: { viewModel.goToNextMonth() }) {
                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding()
                    
                    HStack(spacing: 0) {
                        ForEach(viewModel.weekdays, id: \.self) { weekday in
                            Text(weekday)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                        ForEach(viewModel.calendarDays) { day in
                            CalendarDayView(day: day) {
                                viewModel.selectDate(day.date)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                    .padding(.vertical)
                
                if let selectedDate = viewModel.selectedDate {
                    WorkoutListView(
                        date: selectedDate,
                        workouts: viewModel.workouts(for: selectedDate),
                        coordinator: coordinator,
                        navigationPath: $navigationPath
                    )
                } else {
                    Text("calendar.select.day".localized())
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
        }
        .navigationTitle("calendar.title".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CalendarDayView: View {
    let day: CalendarDay
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(day.dayNumber)")
                    .font(.system(size: 16, weight: day.isToday ? .bold : .regular))
                    .foregroundColor(CalendarDayStyleHelper.foregroundColor(for: day))
                
                if day.hasWorkouts {
                    Circle()
                        .fill(CalendarDayStyleHelper.workoutIndicatorColor(for: day))
                        .frame(width: 6, height: 6)
                } else {
                    Spacer()
                        .frame(height: 6)
                }
            }
            .frame(width: 44, height: 60)
            .background(CalendarDayStyleHelper.backgroundColor(for: day))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        CalendarView(coordinator: AppCoordinator(), navigationPath: .constant(NavigationPath()))
    }
}

