import SwiftUI

// MARK: - Colors
extension Color {
    static let background = Color(hex: "#171212")
    static let primaryButton = Color(hex: "#DB0F0F")
    static let textPrimary = Color.white
    static let textSecondary = Color.gray
    static let textFieldBackground = Color(hex: "#362B2B")
    static let tealBackground = Color(hex: "#70A092")
}

// MARK: - Fonts
enum AppFont {
    static func regular(size: CGFloat) -> Font {
        return Font.custom("Lexend-Regular", size: size)
    }
    
    static func medium(size: CGFloat) -> Font {
        return Font.custom("Lexend-Medium", size: size)
    }
    
    static func semiBold(size: CGFloat) -> Font {
        return Font.custom("Lexend-SemiBold", size: size)
    }
    
    static func bold(size: CGFloat) -> Font {
        return Font.custom("Lexend-Bold", size: size)
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
