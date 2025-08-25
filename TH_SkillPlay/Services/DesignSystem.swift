//
//  DesignSystem.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import SwiftUI

// MARK: - Color System
extension Color {
    // Primary Colors
    static let primaryYellow = Color(hex: "FFD93D")
    static let orangeAccent = Color(hex: "FFB302")
    static let warmRed = Color(hex: "E94F37")
    static let grassGreen = Color(hex: "8BC34A")
    static let skyBlue = Color(hex: "4FC3F7")
    
    // Neutral Colors
    static let darkGray = Color(hex: "333333")
    static let lightGray = Color(hex: "F5F5F5")
    
    // Helper initializer for hex colors
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

// MARK: - Typography System
struct Typography {
    static let sectionHeader = Font.system(size: 20, weight: .bold)
    static let bodyText = Font.system(size: 16, weight: .medium)
    static let buttonText = Font.system(size: 16, weight: .bold)
    static let navigationTitle = Font.system(size: 18, weight: .semibold)
    static let cardTitle = Font.system(size: 18, weight: .semibold)
    static let cardSubtitle = Font.system(size: 14, weight: .medium)
    static let caption = Font.system(size: 12, weight: .regular)
}

// MARK: - Spacing System
struct Spacing {
    static let xs: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    
    static let safeAreaPadding: CGFloat = 16
    static let cardSpacing: CGFloat = 16
    static let sectionHeaderTopPadding: CGFloat = 24
}

// MARK: - UI Constants
struct UIConstants {
    // Buttons
    static let buttonHeight: CGFloat = 52
    static let buttonCornerRadius: CGFloat = 14
    
    // Cards
    static let cardCornerRadius: CGFloat = 18
    
    // Navigation
    static let navigationBarHeight: CGFloat = 56
    
    // Icons
    static let iconSizeSmall: CGFloat = 22
    static let iconSizeMedium: CGFloat = 24
    static let iconSizeLarge: CGFloat = 28
    
    // Animations
    static let animationDuration: Double = 0.3
    static let springAnimationDuration: Double = 0.5
}

// MARK: - Custom Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: UIConstants.buttonHeight)
            .frame(maxWidth: .infinity)
            .background(Color.primaryYellow)
            .foregroundColor(.white)
            .font(Typography.buttonText)
            .cornerRadius(UIConstants.buttonCornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: UIConstants.buttonHeight)
            .frame(maxWidth: .infinity)
            .background(Color.lightGray)
            .foregroundColor(Color.darkGray)
            .font(Typography.buttonText)
            .cornerRadius(UIConstants.buttonCornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Custom Card Style
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(UIConstants.cardCornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

// MARK: - Animation Helpers
struct AnimationHelpers {
    static let fadeIn = AnyTransition.opacity.combined(with: .move(edge: .bottom))
    static let scaleIn = AnyTransition.scale.combined(with: .opacity)
    static let slideIn = AnyTransition.move(edge: .trailing).combined(with: .opacity)
    
    static func staggeredAnimation(index: Int, delay: Double = 0.1) -> Animation {
        .spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * delay)
    }
}