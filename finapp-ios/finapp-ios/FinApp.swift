import SwiftUI

@main
struct FinApp: App {
    // App state
    @StateObject private var appState = AppState()
    @StateObject private var viewModel = AppViewModel()
    
    // App storage for user defaults
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !hasCompletedOnboarding {
                    OnboardingView()
                        .environmentObject(appState)
                        .transition(.opacity)
                } else if !isLoggedIn {
                    LoginView()
                        .environmentObject(appState)
                        .transition(.opacity)
                } else {
                    MainTabView()
                        .environmentObject(appState)
                        .environmentObject(viewModel)
                }
            }
            .animation(.easeInOut, value: hasCompletedOnboarding)
            .animation(.easeInOut, value: isLoggedIn)
            .onAppear {
                // Configure app appearance
                configureAppearance()
            }
        }
    }
    
    private func configureAppearance() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.background)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.background)
        
        // Selected item color
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.primaryButton)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.primaryButton)]
        
        // Unselected item color
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

// MARK: - App State

final class AppState: ObservableObject {
    @Published var selectedTab: Tab = .home
    @Published var showTabBar: Bool = true
    
    // User session data
    @Published var user: User? = nil
    @Published var isAuthenticated: Bool = false
    
    // Navigation paths
    @Published var homeNavigationPath = NavigationPath()
    @Published var cardsNavigationPath = NavigationPath()
    @Published var profileNavigationPath = NavigationPath()
    
    // Other app-wide state properties
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
}

// MARK: - App ViewModel

@MainActor
final class AppViewModel: ObservableObject {
    // Shared business logic and services
    @Published var transactions: [Transaction] = []
    @Published var cards: [Card] = []
    
    // Add your service dependencies here
    // private let apiService: APIService
    // private let authService: AuthService
    
    func loadInitialData() async {
        // Load initial app data
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadTransactions() }
            group.addTask { await self.loadCards() }
        }
    }
    
    private func loadTransactions() async {
        // Implement transaction loading
        // self.transactions = try? await apiService.fetchTransactions()
    }
    
    private func loadCards() async {
        // Implement cards loading
        // self.cards = try? await apiService.fetchCards()
    }
}

// MARK: - Tab Enum

enum Tab: String, CaseIterable, Identifiable {
    case home = "house.fill"
    case statistics = "chart.pie.fill"
    case pay = "dollarsign.circle.fill"
    case cards = "creditcard.fill"
    case profile = "person.fill"
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .statistics: return "Statistics"
        case .pay: return "Pay"
        case .cards: return "Cards"
        case .profile: return "Profile"
        }
    }
}

// MARK: - Preview

#Preview {
    FinApp()
}
}
