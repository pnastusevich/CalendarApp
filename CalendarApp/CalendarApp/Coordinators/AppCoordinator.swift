import SwiftUI

final class AppCoordinator {
    func showWorkoutDetail(_ workout: Workout, in path: Binding<NavigationPath>) {
        path.wrappedValue.append(workout)
    }
    
    func pop(path: Binding<NavigationPath>) {
        if !path.wrappedValue.isEmpty {
            path.wrappedValue.removeLast()
        }
    }
    
    func popToRoot(path: Binding<NavigationPath>) {
        path.wrappedValue.removeLast(path.wrappedValue.count)
    }
}
