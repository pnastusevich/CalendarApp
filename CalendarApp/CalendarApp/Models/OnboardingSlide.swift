import Foundation

struct OnboardingSlide: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String?
    let imageName: String?
    
    init(title: String, description: String, iconName: String? = nil, imageName: String? = nil) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.imageName = imageName
    }
}

