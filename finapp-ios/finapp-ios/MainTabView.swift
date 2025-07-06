import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var viewModel: AppViewModel
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationStack(path: $appState.homeNavigationPath) {
                DashboardView()
                    .navigationDestination(for: String.self) { id in
                        if id == "transactionDetail" {
                            TransactionDetailView()
                        }
                    }
            }
            .tabItem {
                Label(Tab.home.title, systemImage: Tab.home.rawValue)
            }
            .tag(Tab.home)
            
            // Statistics Tab
            NavigationStack {
                StatisticsView()
            }
            .tabItem {
                Label(Tab.statistics.title, systemImage: Tab.statistics.rawValue)
            }
            .tag(Tab.statistics)
            
            // Pay Tab
            NavigationStack {
                PayView()
            }
            .tabItem {
                Label(Tab.pay.title, systemImage: Tab.pay.rawValue)
            }
            .tag(Tab.pay)
            
            // Cards Tab
            NavigationStack(path: $appState.cardsNavigationPath) {
                CardsView()
            }
            .tabItem {
                Label(Tab.cards.title, systemImage: Tab.cards.rawValue)
            }
            .tag(Tab.cards)
            
            // Profile Tab
            NavigationStack(path: $appState.profileNavigationPath) {
                ProfileView()
            }
            .tabItem {
                Label(Tab.profile.title, systemImage: Tab.profile.rawValue)
            }
            .tag(Tab.profile)
        }
        .accentColor(.primaryButton)
        .onChange(of: selectedTab) { newValue in
            appState.selectedTab = newValue
        }
        .onAppear {
            // Ensure the tab bar is visible when this view appears
            appState.showTabBar = true
            
            // Load initial data if needed
            Task {
                await viewModel.loadInitialData()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
        .environmentObject(AppState())
        .environmentObject(AppViewModel())
}
