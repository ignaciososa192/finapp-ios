import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingAddTransaction = false
    
    var body: some View {
        TabView {
            // Home Tab
            AppNavigationView {
                ZStack(alignment: .top) {
                // Background
                Color.background
                    .ignoresSafeArea()
                
                // Content
                ScrollView {
                    VStack(spacing: 0) {
                        // Header with balance
                        VStack(spacing: 16) {
                            // Greeting and profile
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Welcome back,")
                                        .font(AppFont.regular(size: 16))
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    Text("John Doe")
                                        .font(AppFont.bold(size: 24))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Button(action: { showingProfile = true }) {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            
                            // Balance card
                            VStack(spacing: 8) {
                                Text("Total Balance")
                                    .font(AppFont.regular(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(viewModel.balance)
                                    .font(AppFont.bold(size: 36))
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 16) {
                                    Button(action: {}) {
                                        HStack {
                                            Image(systemName: "arrow.down")
                                                .font(.system(size: 14, weight: .bold))
                                            Text("Income")
                                                .font(AppFont.medium(size: 14))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(16)
                                    }
                                    
                                    Button(action: {}) {
                                        HStack {
                                            Image(systemName: "arrow.up")
                                                .font(.system(size: 14, weight: .bold))
                                            Text("Expense")
                                                .font(AppFont.medium(size: 14))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.red.opacity(0.2))
                                        .cornerRadius(16)
                                    }
                                }
                                .padding(.top, 8)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(24)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.primaryButton.opacity(0.8),
                                        Color.primaryButton.opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(24)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 8)
                            .shadow(color: Color.primaryButton.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            // Quick actions
                            HStack(spacing: 16) {
                                QuickActionButton(
                                    icon: "arrow.up.arrow.down",
                                    label: "Transfer",
                                    action: {}
                                )
                                
                                QuickActionButton(
                                    icon: "qrcode.viewfinder",
                                    label: "Scan",
                                    action: {}
                                )
                                
                                QuickActionButton(
                                    icon: "plus",
                                    label: "Top Up",
                                    action: {}
                                )
                                
                                QuickActionButton(
                                    icon: "chart.pie.fill",
                                    label: "Stats",
                                    action: {}
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)
                        }
                        
                        // Recent transactions
                        VStack(spacing: 0) {
                            HStack {
                                Text("Recent Transactions")
                                    .font(AppFont.semiBold(size: 18))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button("See All") {}
                                    .font(AppFont.medium(size: 14))
                                    .foregroundColor(.primaryButton)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding(.vertical, 20)
                            } else if viewModel.recentTransactions.isEmpty {
                                VStack(spacing: 16) {
                                    Image(systemName: "doc.text.magnifyingglass")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                    
                                    Text("No transactions yet")
                                        .font(AppFont.medium(size: 16))
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                LazyVStack(spacing: 0) {
                                    ForEach(viewModel.recentTransactions) { transaction in
                                        NavigationLink(destination: TransactionDetailView(transaction: transaction)) {
                                            TransactionRow(transaction: transaction)
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 20)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        if transaction.id != viewModel.recentTransactions.last?.id {
                                            Divider()
                                                .background(Color.gray.opacity(0.2))
                                                .padding(.leading, 20)
                                        }
                                    }
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.textFieldBackground)
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                    .padding(.bottom, 100) // Extra padding for the FAB
                }
                .refreshable {
                    await withCheckedContinuation { continuation in
                        viewModel.refresh()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            continuation.resume()
                        }
                    }
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingAddTransaction = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.primaryButton)
                                .clipShape(Circle())
                                .shadow(radius: 10)
            .sheet(isPresented: $showingProfile) {
                // Profile view would go here
                Text("Profile")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.background)
            }
        }
    }
}

// MARK: - Subviews

private struct QuickActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.textFieldBackground)
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primaryButton)
                }
                
                Text(label)
                    .font(AppFont.regular(size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

private struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(white: 0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: transaction.category.icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(transaction.type == .income ? .green : .red)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(AppFont.medium(size: 16))
                    .foregroundColor(.white)
                
                Text(transaction.subtitle)
                    .font(AppFont.regular(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.formattedAmount)
                    .font(AppFont.semiBold(size: 16))
                    .foregroundColor(transaction.type == .income ? .green : .white)
                
                Text(transaction.formattedDate)
                    .font(AppFont.regular(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 12)
    }
}

// MARK: - Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Preview

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
