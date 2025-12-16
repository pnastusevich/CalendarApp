import SwiftUI

@main
struct CalendarAppApp: App {
    private let coordinator = AppCoordinator()
    @State private var navigationPath = NavigationPath()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var showOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showOnboarding {
                    OnboardingView(showOnboarding: $showOnboarding)
                } else {
                    TabView {
                        NavigationStack(path: $navigationPath) {
                            CalendarView(coordinator: coordinator, navigationPath: $navigationPath)
                                .navigationDestination(for: Workout.self) { workout in
                                    WorkoutDetailView(workout: workout, coordinator: coordinator)
                                }
                        }
                        .tabItem {
                            Label("calendar.title".localized(), systemImage: "calendar")
                        }
                        
                        ProfileView(viewModel: profileViewModel)
                            .tabItem {
                                Label("profile.title".localized(), systemImage: "person.circle")
                            }
                    }
                }
            }
            .preferredColorScheme(profileViewModel.colorScheme)
            .onAppear {
                showOnboarding = !onboardingViewModel.hasSeenOnboarding
            }
        }
    }
}
