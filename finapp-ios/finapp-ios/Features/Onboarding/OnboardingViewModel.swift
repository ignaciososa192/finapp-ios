import Foundation
import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published private(set) var currentPage = 0
    @Published private(set) var items: [OnboardingItem] = []
    
    var currentItem: OnboardingItem? {
        guard currentPage < items.count else { return nil }
        return items[currentPage]
    }
    
    var isLastPage: Bool {
        currentPage == items.count - 1
    }
    
    init() {
        self.items = OnboardingItem.sampleData
    }
    
    func next() {
        guard currentPage < items.count - 1 else { return }
        withAnimation {
            currentPage += 1
        }
    }
    
    func previous() {
        guard currentPage > 0 else { return }
        withAnimation {
            currentPage -= 1
        }
    }
    
    func skip() {
        // Save that onboarding has been completed
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}
