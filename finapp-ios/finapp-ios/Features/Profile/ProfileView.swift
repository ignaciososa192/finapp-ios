import SwiftUI

struct ProfileView: View {
    @State private var isNotificationsEnabled = true
    @State private var isBiometricEnabled = false
    @State private var showingLogoutAlert = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    // Mock user data
    let user = User(
        name: "John Doe",
        email: "john.doe@example.com",
        phone: "+1 (555) 123-4567",
        joinDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
    )
    
    var body: some View {
        ZStack {
            // Background
            Color.background
                .ignoresSafeArea()
            
            // Content
            ScrollView {
                VStack(spacing: 0) {
                    // Profile Header
                    VStack(spacing: 16) {
                        // Profile Image
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.primaryButton)
                                .background(Color.textFieldBackground)
                                .clipShape(Circle())
                            
                            Button(action: {
                                // Change photo action
                            }) {
                                Image(systemName: "camera.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.primaryButton)
                                    .background(Color.background)
                                    .clipShape(Circle())
                                    .offset(x: 12, y: 12)
                            }
                        }
                        .padding(.top, 24)
                        
                        // User Info
                        VStack(spacing: 4) {
                            Text(user.name)
                                .font(AppFont.bold(size: 24))
                                .foregroundColor(.white)
                            
                            Text(user.email)
                                .font(AppFont.regular(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 16)
                    }
                    
                    // Account Section
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Account")
                            .font(AppFont.semiBold(size: 16))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                        
                        NavigationLink(destination: EditProfileView(user: user)) {
                            ProfileRow(icon: "person.fill", title: "Edit Profile")
                        }
                        
                        NavigationLink(destination: Text("Payment Methods")) {
                            ProfileRow(icon: "creditcard.fill", title: "Payment Methods")
                        }
                        
                        NavigationLink(destination: Text("Transaction History")) {
                            ProfileRow(icon: "clock.arrow.circlepath", title: "Transaction History")
                        }
                    }
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    // Preferences Section
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Preferences")
                            .font(AppFont.semiBold(size: 16))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                        
                        Toggle(isOn: $isNotificationsEnabled) {
                            ProfileRow(icon: "bell.fill", title: "Notifications")
                        }
                        .tint(.primaryButton)
                        .padding(.horizontal, 8)
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.leading, 52)
                        
                        Toggle(isOn: $isBiometricEnabled) {
                            ProfileRow(icon: "faceid", title: "Face ID / Touch ID")
                        }
                        .tint(.primaryButton)
                        .padding(.horizontal, 8)
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.leading, 52)
                        
                        NavigationLink(destination: Text("Currency")) {
                            ProfileRow(icon: "dollarsign.circle.fill", title: "Currency")
                        }
                    }
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Support Section
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Support")
                            .font(AppFont.semiBold(size: 16))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                        
                        NavigationLink(destination: Text("Help Center")) {
                            ProfileRow(icon: "questionmark.circle.fill", title: "Help Center")
                        }
                        
                        NavigationLink(destination: Text("Contact Us")) {
                            ProfileRow(icon: "envelope.fill", title: "Contact Us")
                        }
                        
                        NavigationLink(destination: Text("Terms & Privacy")) {
                            ProfileRow(icon: "doc.text.fill", title: "Terms & Privacy")
                        }
                    }
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Logout Button
                    Button(action: {
                        showingLogoutAlert = true
                    }) {
                        Text("Logout")
                            .font(AppFont.semiBold(size: 16))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.textFieldBackground)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            .padding(.bottom, 40)
                    }
                    .alert(isPresented: $showingLogoutAlert) {
                        Alert(
                            title: Text("Logout"),
                            message: Text("Are you sure you want to logout?"),
                            primaryButton: .destructive(Text("Logout")) {
                                // Logout action
                                isLoggedIn = false
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Subviews

struct ProfileRow: View {
    let icon: String
    let title: String
    var showChevron: Bool = true
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .frame(width: 24)
                .foregroundColor(.primaryButton)
            
            Text(title)
                .font(AppFont.medium(size: 16))
                .foregroundColor(.white)
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
    }
}

// MARK: - Models

struct User {
    let name: String
    let email: String
    let phone: String
    let joinDate: Date
    
    var formattedJoinDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return "Member since \(formatter.string(from: joinDate))"
    }
}

// MARK: - Edit Profile View

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var email: String
    @State private var phone: String
    
    init(user: User) {
        _name = State(initialValue: user.name)
        _email = State(initialValue: user.email)
        _phone = State(initialValue: user.phone)
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Image
                    ZStack(alignment: .bottomTrailing) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.primaryButton)
                            .background(Color.textFieldBackground)
                            .clipShape(Circle())
                        
                        Button(action: {
                            // Change photo action
                        }) {
                            Image(systemName: "camera.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.primaryButton)
                                .background(Color.background)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 24)
                    
                    // Form
                    VStack(spacing: 16) {
                        TextFieldView(
                            placeholder: "Full Name",
                            text: $name,
                            icon: "person.fill"
                        )
                        
                        TextFieldView(
                            placeholder: "Email",
                            text: $email,
                            keyboardType: .emailAddress,
                            icon: "envelope.fill"
                        )
                        
                        TextFieldView(
                            placeholder: "Phone Number",
                            text: $phone,
                            keyboardType: .phonePad,
                            icon: "phone.fill"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Save Button
                    Button(action: {
                        // Save changes
                        dismiss()
                    }) {
                        Text("Save Changes")
                            .font(AppFont.semiBold(size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryButton)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitle("Edit Profile", displayMode: .inline)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
