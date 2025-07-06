import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primaryButton)
                    .frame(height: 56)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .font(AppFont.semiBold(size: 16))
                        .foregroundColor(.white)
                }
            }
        }
        .disabled(isLoading)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var icon: Image? = nil
    var backgroundColor: Color = Color.textFieldBackground
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let icon = icon {
                    icon
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                Text(title)
                    .font(AppFont.medium(size: 16))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundColor)
            .cornerRadius(12)
        }
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            PrimaryButton(title: "Next", action: {})
            PrimaryButton(title: "Loading...", action: {}, isLoading: true)
            SecondaryButton(title: "Login with Google", action: {})
            SecondaryButton(title: "Login with Apple", action: {})
        }
        .padding()
        .background(Color.background)
        .previewLayout(.sizeThatFits)
    }
}
