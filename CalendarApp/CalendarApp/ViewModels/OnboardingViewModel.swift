import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    
    var slides: [OnboardingSlide] {
        [
            OnboardingSlide(
                title: "onboarding.slide1.title".localized(),
                description: "onboarding.slide1.description".localized(),
                imageName: "iconImage"
            ),
            OnboardingSlide(
                title: "onboarding.slide2.title".localized(),
                description: "onboarding.slide2.description".localized(),
                iconName: "chart.line.uptrend.xyaxis"
            )
        ]
    }
    
    private let hasSeenOnboardingKey = "hasSeenOnboarding"
    
    var hasSeenOnboarding: Bool {
        UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: hasSeenOnboardingKey)
    }
    
    func nextPage() {
        if currentPage < slides.count - 1 {
            currentPage += 1
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
    
    var isLastPage: Bool {
        currentPage >= slides.count - 1
    }
    
    var canGoBack: Bool {
        currentPage > 0
    }
    
    var buttonTitle: String {
        isLastPage ? "onboarding.start".localized() : "onboarding.next".localized()
    }
    
    var indexedSlides: [(index: Int, slide: OnboardingSlide)] {
        Array(slides.enumerated().map { (index: $0.offset, slide: $0.element) })
    }
}

