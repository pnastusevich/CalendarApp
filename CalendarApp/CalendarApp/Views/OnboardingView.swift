import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $viewModel.currentPage) {
                    ForEach(viewModel.indexedSlides, id: \.slide.id) { index, slide in
                        OnboardingSlideView(slide: slide)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        if viewModel.canGoBack {
                            Button(action: {
                                viewModel.previousPage()
                            }) {
                                Text("onboarding.back".localized())
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .cornerRadius(12)
                            }
                        }
                        
                        Button(action: {
                            if viewModel.isLastPage {
                                viewModel.completeOnboarding()
                                withAnimation {
                                    showOnboarding = false
                                }
                            } else {
                                viewModel.nextPage()
                            }
                        }) {
                            Text(viewModel.buttonTitle)
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

struct OnboardingSlideView: View {
    let slide: OnboardingSlide
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            if let imageName = slide.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 20)
            } else if let iconName = slide.iconName {
                Image(systemName: iconName)
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
            }
            
            VStack(spacing: 16) {
                Text(slide.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Text(slide.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
        .padding(.vertical, 40)
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
