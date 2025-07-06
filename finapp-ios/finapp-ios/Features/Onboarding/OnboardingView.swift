import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var showLogin = false
    
    var body: some View {
        ZStack {
            // Background colors with animation
            if let currentItem = viewModel.currentItem {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(currentItem.topBackgroundColor)
                        .frame(height: UIScreen.main.bounds.height * 0.4)
                    
                    Rectangle()
                        .fill(currentItem.bottomBackgroundColor)
                }
                .ignoresSafeArea()
                
                // Content
                VStack {
                    // Skip button (only show if not on last page)
                    if !viewModel.isLastPage {
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.skip()
                                showLogin = true
                            }) {
                                Text(Strings.skip)
                                    .font(AppFont.medium(size: 16))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Image/Illustration
                    Image(systemName: currentItem.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.white)
                        .padding(.bottom, 40)
                    
                    // Text content
                    VStack(spacing: 16) {
                        Text(currentItem.title)
                            .font(AppFont.bold(size: 28))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Text(currentItem.description)
                            .font(AppFont.regular(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.bottom, 40)
                    
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<viewModel.items.count, id: \.self) { index in
                            Circle()
                                .fill(index == viewModel.currentPage ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom, 40)
                    
                    // Navigation buttons
                    VStack(spacing: 16) {
                        PrimaryButton(
                            title: viewModel.isLastPage ? Strings.getStarted : Strings.next,
                            action: {
                                if viewModel.isLastPage {
                                    viewModel.skip()
                                    showLogin = true
                                } else {
                                    viewModel.next()
                                }
                            }
                        )
                        
                        if !viewModel.isLastPage {
                            Button(action: {
                                viewModel.skip()
                                showLogin = true
                            }) {
                                Text(Strings.skip)
                                    .font(AppFont.medium(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .animation(.easeInOut, value: viewModel.currentPage)
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
