import Foundation
import SwiftUI

struct OnboardingItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let topBackgroundColor: Color
    let bottomBackgroundColor: Color
    
    static var sampleData: [OnboardingItem] {
        [
            OnboardingItem(
                title: "Welcome to FinApp",
                description: "Take control of your finances with our intuitive app. Manage your money, track expenses, and achieve your financial goals.",
                imageName: "dollarsign.circle.fill",
                topBackgroundColor: .tealBackground,
                bottomBackgroundColor: .background
            ),
            OnboardingItem(
                title: "No more bank visits",
                description: "Manage your finances from anywhere, anytime. Our app puts the power of banking in your pocket, eliminating the need for branch visits.",
                imageName: "building.columns.fill",
                topBackgroundColor: .tealBackground,
                bottomBackgroundColor: .background
            ),
            OnboardingItem(
                title: "Experience seamless financial management",
                description: "All your financial needs in one place. Track spending, set budgets, and grow your savings with ease.",
                imageName: "chart.line.uptrend.xyaxis",
                topBackgroundColor: Color(hex: "#F5F0E6"),
                bottomBackgroundColor: .background
            )
        ]
    }
}
