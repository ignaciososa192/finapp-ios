import SwiftUI
import CoreImage.CIFilterBuiltins

struct PayView: View {
    @StateObject private var viewModel = PayViewModel()
    @State private var amount: String = ""
    @State private var note: String = ""
    @State private var showingScanner = false
    @State private var showingContacts = false
    @State private var selectedContact: Contact?
    @State private var isSending = false
    
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
                        Text("Send Money")
                            .font(AppFont.bold(size: 28))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Scan QR Code Button
                        Button(action: { showingScanner = true }) {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.primaryButton)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Recipient Card
                    VStack(spacing: 16) {
                        if let contact = selectedContact {
                            // Selected contact
                            VStack(spacing: 12) {
                                ZStack(alignment: .bottomTrailing) {
                                    // Contact image or initial
                                    if let image = contact.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                    } else {
                                        Text(contact.initials)
                                            .font(AppFont.bold(size: 24))
                                            .foregroundColor(.white)
                                            .frame(width: 80, height: 80)
                                            .background(Color.primaryButton)
                                            .clipShape(Circle())
                                    }
                                    
                                    // Online status indicator
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 16, height: 16)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.background, lineWidth: 2)
                                        )
                                }
                                
                                VStack(spacing: 4) {
                                    Text(contact.name)
                                        .font(AppFont.semiBold(size: 18))
                                        .foregroundColor(.white)
                                    
                                    Text(contact.phone)
                                        .font(AppFont.regular(size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        selectedContact = nil
                                    }
                                }) {
                                    Text("Change")
                                        .font(AppFont.medium(size: 14))
                                        .foregroundColor(.primaryButton)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .background(Color.primaryButton.opacity(0.1))
                                        .cornerRadius(12)
                                }
                            }
                            .padding(.vertical, 16)
                        } else {
                            // No contact selected - show add button
                            Button(action: { showingContacts = true }) {
                                VStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                                            .foregroundColor(.gray.opacity(0.5))
                                            .frame(width: 80, height: 80)
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.primaryButton)
                                    }
                                    
                                    Text("Select Contact")
                                        .font(AppFont.medium(size: 16))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    // Amount Input
                    VStack(spacing: 16) {
                        // Amount field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Amount")
                                .font(AppFont.medium(size: 14))
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 8) {
                                Text("$")
                                    .font(AppFont.bold(size: 28))
                                    .foregroundColor(.white)
                                
                                TextField("0.00", text: $amount)
                                    .font(AppFont.bold(size: 28))
                                    .foregroundColor(.white)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: amount) { newValue in
                                        // Format the amount as user types
                                        let filtered = newValue.filter { "0123456789.".contains($0) }
                                        if filtered != newValue {
                                            self.amount = filtered
                                        }
                                    }
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.textFieldBackground.opacity(0.5))
                            .cornerRadius(12)
                        }
                        
                        // Quick amount buttons
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Quick Amount")
                                .font(AppFont.medium(size: 14))
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 12) {
                                ForEach(["10", "50", "100", "200"], id: \.self) { value in
                                    Button(action: {
                                        withAnimation {
                                            amount = value
                                        }
                                    }) {
                                        Text("$\(value)")
                                            .font(AppFont.medium(size: 16))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.textFieldBackground)
                                            .cornerRadius(12)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        
                        // Note field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note (Optional)")
                                .font(AppFont.medium(size: 14))
                                .foregroundColor(.gray)
                            
                            TextField("Add a note...", text: $note)
                                .font(AppFont.regular(size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.textFieldBackground.opacity(0.5))
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Send Button
                    Button(action: {
                        // Send money action
                        isSending = true
                        // Simulate network request
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isSending = false
                            // Show success state
                            viewModel.showSuccess = true
                        }
                    }) {
                        if isSending {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primaryButton.opacity(0.7))
                                .cornerRadius(12)
                        } else {
                            Text("Send Money")
                                .font(AppFont.semiBold(size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedContact != nil && !amount.isEmpty ? Color.primaryButton : Color.gray.opacity(0.5))
                                .cornerRadius(12)
                        }
                    }
                    .disabled(selectedContact == nil || amount.isEmpty || isSending)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .sheet(isPresented: $showingContacts) {
            ContactsView(selectedContact: $selectedContact)
        }
        .sheet(isPresented: $showingScanner) {
            QRScannerView()
        }
        .alert(isPresented: $viewModel.showSuccess) {
            Alert(
                title: Text("Success"),
                message: Text("Your payment of $\(amount) has been sent successfully."),
                dismissButton: .default(Text("OK")) {
                    // Reset form
                    amount = ""
                    note = ""
                    selectedContact = nil
                }
            )
        }
    }
}

// MARK: - View Models

@MainActor
final class PayViewModel: ObservableObject {
    @Published var showSuccess = false
}

// MARK: - Contacts View

struct ContactsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedContact: Contact?
    
    @State private var searchText = ""
    @State private var contacts: [Contact] = []
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.phone.contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search contacts...", text: $searchText)
                        .font(AppFont.regular(size: 16))
                        .foregroundColor(.white)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(12)
                .background(Color.textFieldBackground)
                .cornerRadius(12)
                .padding()
                
                // Contacts list
                List {
                    ForEach(filteredContacts) { contact in
                        Button(action: {
                            selectedContact = contact
                            dismiss()
                        }) {
                            HStack(spacing: 12) {
                                // Contact image or initial
                                if let image = contact.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                } else {
                                    Text(contact.initials)
                                        .font(AppFont.semiBold(size: 16))
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.primaryButton)
                                        .clipShape(Circle())
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(contact.name)
                                        .font(AppFont.medium(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Text(contact.phone)
                                        .font(AppFont.regular(size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                if contact.isFavorite {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.background)
            }
            .background(Color.background)
            .navigationTitle("Select Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryButton)
                }
            }
        }
        .onAppear {
            // Load contacts
            loadContacts()
        }
    }
    
    private func loadContacts() {
        // Mock contacts
        contacts = [
            Contact(
                id: "1",
                name: "Sarah Johnson",
                phone: "+1 (555) 123-4567",
                isFavorite: true,
                initials: "SJ"
            ),
            Contact(
                id: "2",
                name: "Michael Chen",
                phone: "+1 (555) 234-5678",
                isFavorite: false,
                initials: "MC"
            ),
            Contact(
                id: "3",
                name: "Emily Davis",
                phone: "+1 (555) 345-6789",
                isFavorite: true,
                initials: "ED"
            ),
            Contact(
                id: "4",
                name: "Robert Wilson",
                phone: "+1 (555) 456-7890",
                isFavorite: false,
                initials: "RW"
            )
        ]
    }
}

// MARK: - QR Scanner View

struct QRScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isScanning = false
    @State private var scannedCode: String? = nil
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            // QR Code Scanner would go here
            // In a real app, you would use AVFoundation to scan QR codes
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Position the QR code within the frame to scan")
                    .font(AppFont.medium(size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Scanner frame
                ZStack {
                    // Scanner overlay
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primaryButton, lineWidth: 2)
                        .frame(width: 250, height: 250)
                    
                    // Scanner animation
                    if isScanning {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.primaryButton.opacity(0.2))
                            .frame(width: 250, height: 4)
                            .offset(y: -120)
                            .animation(
                                Animation.linear(duration: 2).repeatForever(autoreverses: true),
                                value: isScanning
                            )
                    }
                }
                .padding(.vertical, 40)
                
                Spacer()
                
                // Flashlight button
                Button(action: {
                    // Toggle flashlight
                }) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.5))
                        .clipShape(Circle())
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .onAppear {
            isScanning = true
            // In a real app, you would start the QR code scanner here
        }
        .onDisappear {
            isScanning = false
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Models

struct Contact: Identifiable {
    let id: String
    let name: String
    let phone: String
    var image: UIImage? = nil
    var isFavorite: Bool = false
    var initials: String
}

// MARK: - Preview

struct PayView_Previews: PreviewProvider {
    static var previews: some View {
        PayView()
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(selectedContact: .constant(nil))
    }
}

struct QRScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRScannerView()
    }
}
