import Foundation

// MARK: - Localization

enum Strings {
    // Common
    static let next = NSLocalizedString("Next", comment: "Next button title")
    static let skip = NSLocalizedString("Skip", comment: "Skip button title")
    static let done = NSLocalizedString("Done", comment: "Done button title")
    static let cancel = NSLocalizedString("Cancel", comment: "Cancel button title")
    static let ok = NSLocalizedString("OK", comment: "OK button title")
    static let error = NSLocalizedString("Error", comment: "Error title")
    
    // Onboarding
    static let welcomeTitle = NSLocalizedString("Welcome to FinApp", comment: "Welcome title")
    static let welcomeDescription = NSLocalizedString("Take control of your finances with our intuitive app. Manage your money, track expenses, and achieve your financial goals.", comment: "Welcome description")
    static let noMoreBankVisits = NSLocalizedString("No more bank visits", comment: "Onboarding title")
    static let bankVisitsDescription = NSLocalizedString("Manage your finances from anywhere, anytime. Our app puts the power of banking in your pocket, eliminating the need for branch visits.", comment: "Bank visits description")
    static let seamlessExperience = NSLocalizedString("Experience seamless financial management", comment: "Seamless experience title")
    static let seamlessDescription = NSLocalizedString("All your financial needs in one place. Track spending, set budgets, and grow your savings with ease.", comment: "Seamless experience description")
    
    // Login
    static let welcomeBack = NSLocalizedString("Welcome back", comment: "Welcome back title")
    static let username = NSLocalizedString("Username", comment: "Username placeholder")
    static let password = NSLocalizedString("Password", comment: "Password placeholder")
    static let forgotPassword = NSLocalizedString("Forgot Password?", comment: "Forgot password button")
    static let login = NSLocalizedString("Login", comment: "Login button title")
    static let orContinueWith = NSLocalizedString("or continue with", comment: "Divider text for social login")
    static let loginWithGoogle = NSLocalizedString("Login with Google", comment: "Google login button")
    static let loginWithApple = NSLocalizedString("Login with Apple", comment: "Apple login button")
    static let dontHaveAccount = NSLocalizedString("Don't have an account?", comment: "Sign up prompt")
    static let register = NSLocalizedString("Register", comment: "Register button title")
    
    // Dashboard
    static let welcomeBackUser = NSLocalizedString("Welcome back,", comment: "Welcome back greeting")
    static let totalBalance = NSLocalizedString("Total Balance", comment: "Total balance title")
    static let income = NSLocalizedString("Income", comment: "Income button title")
    static let expense = NSLocalizedString("Expense", comment: "Expense button title")
    static let transfer = NSLocalizedString("Transfer", comment: "Transfer button title")
    static let scan = NSLocalizedString("Scan", comment: "Scan button title")
    static let topUp = NSLocalizedString("Top Up", comment: "Top up button title")
    static let stats = NSLocalizedString("Stats", comment: "Stats button title")
    static let recentTransactions = NSLocalizedString("Recent Transactions", comment: "Recent transactions section title")
    static let seeAll = NSLocalizedString("See All", comment: "See all button title")
    static let noTransactions = NSLocalizedString("No transactions yet", comment: "Empty state message")
    
    // Tab Bar
    static let home = NSLocalizedString("Home", comment: "Home tab title")
    static let transactions = NSLocalizedString("Transactions", comment: "Transactions tab title")
    static let cards = NSLocalizedString("Cards", comment: "Cards tab title")
    static let profile = NSLocalizedString("Profile", comment: "Profile tab title")
    
    // Errors
    static let usernameRequired = NSLocalizedString("Username is required", comment: "Username validation error")
    static let passwordRequired = NSLocalizedString("Password is required", comment: "Password validation error")
    static let passwordTooShort = NSLocalizedString("Password must be at least 6 characters", comment: "Password length error")
    static let invalidCredentials = NSLocalizedString("Invalid username or password", comment: "Login error message")
}

// MARK: - String Extension for Localization

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
