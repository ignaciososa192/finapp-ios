import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var balance: String = "$12,450.00"
    @Published var recentTransactions: [Transaction] = []
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        loadDashboardData()
    }
    
    // MARK: - Public Methods
    func refresh() {
        loadDashboardData()
    }
    
    // MARK: - Private Methods
    private func loadDashboardData() {
        isLoading = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            // Mock data - in a real app, this would come from a service/repository
            self.recentTransactions = [
                Transaction(
                    id: "1",
                    title: "Grocery Store",
                    subtitle: "Groceries",
                    amount: -125.50,
                    date: Date().addingTimeInterval(-86400 * 2), // 2 days ago
                    type: .expense,
                    category: .food
                ),
                Transaction(
                    id: "2",
                    title: "Salary",
                    subtitle: "Monthly Salary",
                    amount: 4500.00,
                    date: Date().addingTimeInterval(-86400 * 5), // 5 days ago
                    type: .income,
                    category: .salary
                ),
                Transaction(
                    id: "3",
                    title: "Electric Bill",
                    subtitle: "Monthly Bill",
                    amount: -85.75,
                    date: Date().addingTimeInterval(-86400 * 7), // 1 week ago
                    type: .expense,
                    category: .bills
                ),
                Transaction(
                    id: "4",
                    title: "Coffee Shop",
                    subtitle: "Food & Drinks",
                    amount: -4.50,
                    date: Date().addingTimeInterval(-3600 * 2), // 2 hours ago
                    type: .expense,
                    category: .food
                )
            ]
            
            self.isLoading = false
        }
    }
}

// MARK: - Transaction Model
struct Transaction: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let amount: Double
    let date: Date
    let type: TransactionType
    let category: TransactionCategory
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        let amountString = formatter.string(from: NSNumber(value: abs(amount))) ?? "$0.00"
        return type == .expense ? "-\(amountString)" : "\(amountString)"
    }
    
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

enum TransactionType: String, Codable, Hashable {
    case income = "income"
    case expense = "expense"
}

enum TransactionCategory: String, Codable, Hashable, CaseIterable {
    case food = "Food & Drinks"
    case shopping = "Shopping"
    case transport = "Transport"
    case bills = "Bills"
    case salary = "Salary"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .shopping: return "bag.fill"
        case .transport: return "car.fill"
        case .bills: return "doc.text.fill"
        case .salary: return "dollarsign.circle.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
}
