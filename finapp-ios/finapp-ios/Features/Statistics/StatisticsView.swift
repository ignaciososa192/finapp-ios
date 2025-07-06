import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var selectedTimeRange: TimeRange = .week
    @State private var selectedCategory: TransactionCategory?
    
    enum TimeRange: String, CaseIterable, Identifiable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.background
                .ignoresSafeArea()
            
            // Content
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Text("Statistics")
                            .font(AppFont.bold(size: 28))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Time range picker
                        Picker("Time Range", selection: $selectedTimeRange) {
                            ForEach(TimeRange.allCases) { range in
                                Text(range.rawValue)
                                    .tag(range)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Balance Card
                    VStack(spacing: 16) {
                        HStack {
                            Text("Total Balance")
                                .font(AppFont.regular(size: 14))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Text("This Month")
                                    .font(AppFont.medium(size: 12))
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.textFieldBackground)
                            .cornerRadius(12)
                        }
                        
                        HStack(alignment: .bottom, spacing: 8) {
                            Text("$12,450.00")
                                .font(AppFont.bold(size: 32))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up")
                                    .font(.system(size: 12, weight: .bold))
                                
                                Text("12.5%")
                                    .font(AppFont.semiBold(size: 14))
                            }
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.bottom, 4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Chart
                        Chart {
                            ForEach(viewModel.chartData) { data in
                                LineMark(
                                    x: .value("Date", data.date),
                                    y: .value("Amount", data.amount)
                                )
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                .foregroundStyle(Color.primaryButton.gradient)
                                .interpolationMethod(.catmullRom)
                                
                                PointMark(
                                    x: .value("Date", data.date),
                                    y: .value("Amount", data.amount)
                                )
                                .foregroundStyle(Color.primaryButton)
                            }
                        }
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                        .frame(height: 120)
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    // Categories
                    VStack(spacing: 16) {
                        HStack {
                            Text("Categories")
                                .font(AppFont.semiBold(size: 18))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button("See All") {}
                                .font(AppFont.medium(size: 14))
                                .foregroundColor(.primaryButton)
                        }
                        .padding(.horizontal, 20)
                        
                        // Category grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(Array(viewModel.categories.prefix(6)), id: \.id) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory?.id == category.id
                                ) {
                                    withAnimation {
                                        if selectedCategory?.id == category.id {
                                            selectedCategory = nil
                                        } else {
                                            selectedCategory = category
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 8)
                    
                    // Recent Transactions
                    VStack(spacing: 16) {
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
                        
                        if viewModel.recentTransactions.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "chart.bar.doc.horizontal")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                
                                Text("No transactions yet")
                                    .font(AppFont.medium(size: 16))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 60)
                            .background(Color.textFieldBackground)
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(viewModel.recentTransactions.prefix(5)) { transaction in
                                    TransactionRow(transaction: transaction)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 20)
                                    
                                    if transaction.id != viewModel.recentTransactions.prefix(5).last?.id {
                                        Divider()
                                            .background(Color.gray.opacity(0.2))
                                            .padding(.leading, 20)
                                    }
                                }
                            }
                            .background(Color.textFieldBackground)
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

// MARK: - Subviews

private struct CategoryButton: View {
    let category: TransactionCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.primaryButton : Color.textFieldBackground)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.iconName)
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? .white : .primaryButton)
                }
                
                Text(category.name)
                    .font(AppFont.medium(size: 12))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - ViewModel

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published var chartData: [ChartDataPoint] = []
    @Published var categories: [TransactionCategory] = []
    @Published var recentTransactions: [Transaction] = []
    
    func loadData() {
        // Mock data loading
        loadChartData()
        loadCategories()
        loadRecentTransactions()
    }
    
    private func loadChartData() {
        // Generate mock chart data
        var data: [ChartDataPoint] = []
        let now = Date()
        let calendar = Calendar.current
        
        for day in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -day, to: now) {
                let amount = Double.random(in: 100...1000)
                data.append(ChartDataPoint(date: date, amount: amount))
            }
        }
        
        self.chartData = data.sorted { $0.date < $1.date }
    }
    
    private func loadCategories() {
        // Mock categories
        self.categories = [
            TransactionCategory(id: "1", name: "Food", iconName: "fork.knife", color: .red, percentage: 0.35),
            TransactionCategory(id: "2", name: "Shopping", iconName: "cart.fill", color: .blue, percentage: 0.25),
            TransactionCategory(id: "3", name: "Transport", iconName: "car.fill", color: .green, percentage: 0.15),
            TransactionCategory(id: "4", name: "Bills", iconName: "doc.text.fill", color: .orange, percentage: 0.10),
            TransactionCategory(id: "5", name: "Entertainment", iconName: "film.fill", color: .purple, percentage: 0.08),
            TransactionCategory(id: "6", name: "Others", iconName: "ellipsis", color: .gray, percentage: 0.07)
        ]
    }
    
    private func loadRecentTransactions() {
        // Mock transactions
        let categories: [TransactionCategory] = [
            TransactionCategory(id: "1", name: "Food", iconName: "fork.knife", color: .red, percentage: 0.0),
            TransactionCategory(id: "2", name: "Shopping", iconName: "cart.fill", color: .blue, percentage: 0.0),
            TransactionCategory(id: "3", name: "Transport", iconName: "car.fill", color: .green, percentage: 0.0),
            TransactionCategory(id: "4", name: "Bills", iconName: "doc.text.fill", color: .orange, percentage: 0.0)
        ]
        
        self.recentTransactions = [
            Transaction(
                id: "1",
                title: "Grocery Store",
                subtitle: "Groceries",
                amount: -125.50,
                date: Date().addingTimeInterval(-3600 * 2),
                type: .expense,
                category: categories[0]
            ),
            Transaction(
                id: "2",
                title: "Salary",
                subtitle: "Monthly Salary",
                amount: 4500.00,
                date: Date().addingTimeInterval(-86400 * 1),
                type: .income,
                category: categories[1]
            ),
            Transaction(
                id: "3",
                title: "Electric Bill",
                subtitle: "Monthly Bill",
                amount: -85.30,
                date: Date().addingTimeInterval(-86400 * 2),
                type: .expense,
                category: categories[3]
            )
        ]
    }
}

// MARK: - Models

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}

// MARK: - Preview

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
