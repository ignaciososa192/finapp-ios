import SwiftUI

struct TextFieldView: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var error: String? = nil
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var returnKeyType: UIReturnKeyType = .done
    var onCommit: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                }
                
                if isSecure {
                    SecureField("", text: $text, onCommit: { onCommit?() })
                        .textContentType(textContentType)
                        .keyboardType(keyboardType)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 8)
                } else {
                    TextField("", text: $text, onCommit: { onCommit?() })
                        .textContentType(textContentType)
                        .keyboardType(keyboardType)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 8)
                }
            }
            .frame(height: 56)
            .background(Color.textFieldBackground)
            .cornerRadius(12)
            
            if let error = error, !error.isEmpty {
                Text(error)
                    .font(AppFont.regular(size: 12))
                    .foregroundColor(.red)
                    .padding(.horizontal, 16)
            }
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    @State static var username = ""
    @State static var password = ""
    
    static var previews: some View {
        VStack(spacing: 20) {
            TextFieldView(
                placeholder: "Username",
                text: $username,
                textContentType: .username
            )
            
            TextFieldView(
                placeholder: "Password",
                text: $password,
                isSecure: true,
                textContentType: .password
            )
            
            TextFieldView(
                placeholder: "With Error",
                text: $username,
                error: "This field is required"
            )
        }
        .padding()
        .background(Color.background)
        .previewLayout(.sizeThatFits)
    }
}
