import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isPasswordVisible = false
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            // App Icon
                            Image(systemName: "dollarsign.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.primaryButton)
                            
                            Text("Welcome back")
                                .font(AppFont.bold(size: 28))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 40)
                        
                        // Form
                        VStack(spacing: 20) {
                            // Username Field
                            TextFieldView(
                                placeholder: "Username",
                                text: $viewModel.username,
                                error: viewModel.usernameError,
                                textContentType: .username
                            )
                            
                            // Password Field
                            ZStack(alignment: .trailing) {
                                if isPasswordVisible {
                                    TextFieldView(
                                        placeholder: "Password",
                                        text: $viewModel.password,
                                        error: viewModel.passwordError,
                                        isSecure: false,
                                        textContentType: .password
                                    )
                                } else {
                                    TextFieldView(
                                        placeholder: "Password",
                                        text: $viewModel.password,
                                        error: viewModel.passwordError,
                                        isSecure: true,
                                        textContentType: .password
                                    )
                                }
                                
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }
                            
                            // Forgot Password
                            HStack {
                                Spacer()
                                Button(action: {
                                    // Handle forgot password
                                }) {
                                    Text(Strings.forgotPassword)
                                        .font(AppFont.medium(size: 14))
                                        .foregroundColor(.primaryButton)
                                }
                            }
                            .padding(.top, -8)
                            
                            // Login Button
                            PrimaryButton(
                                title: Strings.login,
                                action: {
                                    if viewModel.validate() {
                                        viewModel.login()
                                        navigateToHome = true
                                    }
                                },
                                isLoading: viewModel.isLoading
                            )
                            .padding(.top, 16)
                            
                            // Divider
                            HStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 1)
                                
                                Text(Strings.orContinueWith)
                                    .font(AppFont.regular(size: 14))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 8)
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 1)
                            }
                            .padding(.vertical, 16)
                            
                            // Social Login Buttons
                            VStack(spacing: 12) {
                                SecondaryButton(
                                    title: Strings.loginWithGoogle,
                                    action: {
                                        viewModel.loginWithGoogle()
                                    },
                                    icon: Image("google-icon") // You'll need to add this asset
                                )
                                
                                SecondaryButton(
                                    title: Strings.loginWithApple,
                                    action: {
                                        viewModel.loginWithApple()
                                    },
                                    icon: Image(systemName: "applelogo")
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Sign Up Link
                        HStack {
                            Text(Strings.dontHaveAnAccount)
                                .font(AppFont.regular(size: 14))
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                // Navigate to sign up
                            }) {
                                Text(Strings.register)
                                    .font(AppFont.semiBold(size: 14))
                                    .foregroundColor(.primaryButton)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
