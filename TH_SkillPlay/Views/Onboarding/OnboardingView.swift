//
//  OnboardingView.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentSlide = 0
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Background with smooth color transition
            LinearGradient(
                gradient: Gradient(colors: [
                    colorFromString(appViewModel.onboardingSlides[safe: currentSlide]?.backgroundColor ?? "primaryYellow"),
                    colorFromString(appViewModel.onboardingSlides[safe: currentSlide]?.backgroundColor ?? "primaryYellow").opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.6), value: currentSlide)
            
            VStack(spacing: 0) {
                Spacer()
                
                // Content
                if showContent && !appViewModel.onboardingSlides.isEmpty {
                    OnboardingSlideView(
                        slide: appViewModel.onboardingSlides[currentSlide],
                        isVisible: showContent
                    )
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity.combined(with: .move(edge: .leading))
                    ))
                }
                
                Spacer()
                
                // Navigation Controls
                VStack(spacing: Spacing.large) {
                    // Page Indicator
                    HStack(spacing: Spacing.small) {
                        ForEach(0..<appViewModel.onboardingSlides.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentSlide ? Color.white : Color.white.opacity(0.4))
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == currentSlide ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3), value: currentSlide)
                        }
                    }
                    
                    // Action Buttons
                    HStack(spacing: Spacing.medium) {
                        if currentSlide > 0 {
                            Button("Back") {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    currentSlide -= 1
                                }
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .transition(.move(edge: .leading).combined(with: .opacity))
                        }
                        
                        Spacer()
                        
                        if currentSlide < appViewModel.onboardingSlides.count - 1 {
                            Button("Next") {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    currentSlide += 1
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        } else {
                            Button("Get Started") {
                                appViewModel.completeOnboarding()
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .scaleEffect(showContent ? 1.0 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: showContent)
                        }
                    }
                    .padding(.horizontal, Spacing.safeAreaPadding)
                }
                .padding(.bottom, Spacing.safeAreaPadding)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3)) {
                showContent = true
            }
        }
        .onChange(of: currentSlide) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                showContent = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showContent = true
                }
            }
        }
    }
}

struct OnboardingSlideView: View {
    let slide: OnboardingSlide
    let isVisible: Bool
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: slide.systemImageName)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(colorFromString(slide.iconColor))
                    .scaleEffect(isVisible ? 1.0 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: isVisible)
            }
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .animation(.spring(response: 0.8, dampingFraction: 0.7), value: isVisible)
            
            // Text Content
            VStack(spacing: Spacing.medium) {
                Text(slide.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isVisible)
                
                Text(slide.subtitle)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, Spacing.large)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 30)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: isVisible)
            }
        }
        .padding(.horizontal, Spacing.safeAreaPadding)
    }
}

// MARK: - Safe Array Extension
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Color Helper Function
private func colorFromString(_ colorName: String) -> Color {
    switch colorName {
    case "primaryYellow":
        return Color.primaryYellow
    case "orangeAccent":
        return Color.orangeAccent
    case "warmRed":
        return Color.warmRed
    case "grassGreen":
        return Color.grassGreen
    case "skyBlue":
        return Color.skyBlue
    case "white":
        return Color.white
    case "darkGray":
        return Color.darkGray
    default:
        return Color.primaryYellow
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}