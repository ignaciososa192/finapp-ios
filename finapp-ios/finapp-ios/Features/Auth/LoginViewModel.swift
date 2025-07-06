import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - Input
    @Published var username: String = ""
    @Published var password: String = ""
    
    // MARK: - Output
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated: Bool = false
    
    // MARK: - Form Validation
    var usernameError: String? {
        if username.isEmpty {
            return "Username is required"
        }
        return nil
    }
    
    var passwordError: String? {
        if password.isEmpty {
            return "Password is required"
        }
        if password.count < 6 {
            return "Password must be at least 6 characters"
        }
        return nil
    }
    
    var isValid: Bool {
        usernameError == nil && passwordError == nil
    }
    
    // MARK: - Public Methods
    
    /// Validates the form and returns true if valid
    func validate() -> Bool {
        // Force validation by accessing the computed properties
        _ = usernameError
        _ = passwordError
        return isValid
    }
    
    /// Handles the login process
    func login() {
        guard validate() else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Mock authentication - in a real app, this would call an API
            if self.username.lowercased() == "demo" && self.password == "password" {
                // Success
                self.isAuthenticated = true
                // Save auth token or user data here
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
            } else {
                // Failure
                self.errorMessage = "Invalid username or password"
            }
            
            self.isLoading = false
        }
    }
    
    /// Handles Google login
    func loginWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        // Simulate Google login
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            // In a real app, handle Google Sign In and get user data
            // For now, just simulate success
            self?.isAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
    }
    
    /// Handles Apple login
    func loginWithApple() {
        isLoading = true
        errorMessage = nil
        
        // Simulate Apple login
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            // In a real app, handle Apple Sign In and get user data
            // For now, just simulate success
            self?.isAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
    }
}
