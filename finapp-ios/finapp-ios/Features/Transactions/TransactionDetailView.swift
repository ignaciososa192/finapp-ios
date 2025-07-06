import SwiftUI

struct TransactionDetailView: View {
    let transaction: Transaction
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
            Color.background
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.textFieldBackground)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Transaction Details")
                        .font(AppFont.semiBold(size: 18))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Invisible view for layout balance
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                // Transaction card
                VStack(spacing: 24) {
                    // Amount
                    VStack(spacing: 8) {
                        Text(transaction.formattedAmount)
                            .font(AppFont.bold(size: 36))
                            .foregroundColor(transaction.type == .income ? .green : .white)
                        
                        Text(transaction.title)
                            .font(AppFont.medium(size: 18))
                            .foregroundColor(.white)
                        
                        Text(transaction.subtitle)
                            .font(AppFont.regular(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    // Details card
                    VStack(spacing: 16) {
                        // Date
                        DetailRow(icon: "calendar", title: "Date", value: formatDate(transaction.date))
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        
                        // Category
                        DetailRow(
                            icon: transaction.category.icon,
                            title: "Category",
                            value: transaction.category.rawValue
                        )
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        
                        // Status
                        DetailRow(
                            icon: "checkmark.circle.fill",
                            title: "Status",
                            value: "Completed",
                            valueColor: .green
                        )
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        
                        // Transaction ID
                        DetailRow(icon: "number", title: "Transaction ID", value: transaction.id)
                    }
                    .padding()
                    .background(Color.textFieldBackground)
                    .cornerRadius(12)
                    
                    // Action buttons
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .font(AppFont.medium(size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.textFieldBackground)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "printer")
                                Text("Print")
                            }
                            .font(AppFont.medium(size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.textFieldBackground)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Subviews

private struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    var valueColor: Color = .white
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .frame(width: 24)
            
            Text(title)
                .font(AppFont.regular(size: 14))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(AppFont.medium(size: 14))
                .foregroundColor(valueColor)
        }
    }
}

// MARK: - Preview

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let transaction = Transaction(
            id: "1234567890",
            title: "Grocery Store",
            subtitle: "Groceries",
            amount: -125.50,
            date: Date(),
            type: .expense,
            category: .food
        )
        
        TransactionDetailView(transaction: transaction)
    }
}
