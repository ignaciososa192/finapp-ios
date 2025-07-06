import SwiftUI

struct CardsView: View {
    @State private var showingAddCard = false
    
    var body: some View {
        ZStack {
            // Background
            Color.background
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("My Cards")
                        .font(AppFont.bold(size: 28))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { showingAddCard = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.primaryButton)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                // Cards Carousel
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        // Add Card Button
                        Button(action: { showingAddCard = true }) {
                            VStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                                        .foregroundColor(.gray.opacity(0.5))
                                        .frame(width: 180, height: 240)
                                    
                                    VStack(spacing: 8) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(.primaryButton)
                                        
                                        Text("Add Card")
                                            .font(AppFont.medium(size: 16))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.leading, 20)
                        }
                        
                        // Sample Card 1
                        CardView(
                            card: Card(
                                id: "1",
                                number: "•••• •••• •••• 1234",
                                holderName: "JOHN DOE",
                                expiryDate: "12/25",
                                type: .visa,
                                color: .blue
                            )
                        )
                        
                        // Sample Card 2
                        CardView(
                            card: Card(
                                id: "2",
                                number: "•••• •••• •••• 5678",
                                holderName: "JOHN DOE",
                                expiryDate: "06/26",
                                type: .mastercard,
                                color: .red
                            )
                        )
                        .padding(.trailing, 20)
                    }
                }
                .frame(height: 280)
                
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
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                    
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "creditcard")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("No recent transactions")
                            .font(AppFont.medium(size: 16))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingAddCard) {
            // Add card view would go here
            Text("Add New Card")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
        }
    }
}

// MARK: - Card View

struct CardView: View {
    let card: Card
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(card.type.rawValue.uppercased())
                    .font(AppFont.bold(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(card.type == .visa ? "visa" : "mastercard")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
            }
            
            Spacer()
            
            Text(card.number)
                .font(AppFont.medium(size: 16))
                .foregroundColor(.white)
                .padding(.vertical, 12)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("CARD HOLDER")
                        .font(AppFont.regular(size: 10))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(card.holderName)
                        .font(AppFont.medium(size: 14))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("EXPIRES")
                        .font(AppFont.regular(size: 10))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(card.expiryDate)
                        .font(AppFont.medium(size: 14))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(20)
        .frame(width: 280, height: 240)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    card.color,
                    card.color.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(24)
        .shadow(color: card.color.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Models

struct Card: Identifiable {
    let id: String
    let number: String
    let holderName: String
    let expiryDate: String
    let type: CardType
    let color: Color
}

enum CardType: String {
    case visa = "Visa"
    case mastercard = "Mastercard"
    case amex = "American Express"
}

// MARK: - Preview

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
