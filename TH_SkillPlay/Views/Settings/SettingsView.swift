//
//  SettingsView.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color.lightGray
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.large) {
                    // Header
                    SettingsHeaderView()
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                    
                    // Settings Sections
                    VStack(spacing: Spacing.medium) {
                        // App Preferences
                        SettingsSection(title: "Preferences") {
                            SettingsToggle(
                                title: "Animations",
                                subtitle: "Enable smooth animations and transitions",
                                iconName: "wand.and.stars",
                                iconColor: Color.orangeAccent,
                                isOn: $appViewModel.settings.animationsEnabled
                            )
                            
                            SettingsToggle(
                                title: "Notifications",
                                subtitle: "Receive daily reminders and updates",
                                iconName: "bell.fill",
                                iconColor: Color.warmRed,
                                isOn: $appViewModel.settings.notificationsEnabled
                            )
                        }
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showContent)
                        
                        // Progress Section
                        SettingsSection(title: "Your Progress") {
                            ProgressCard(
                                title: "Total Points",
                                value: "\(appViewModel.userProgress.totalPoints)",
                                iconName: "star.fill",
                                iconColor: Color.primaryYellow
                            )
                            
                            ProgressCard(
                                title: "Current Streak",
                                value: "\(appViewModel.userProgress.currentStreak) days",
                                iconName: "flame.fill",
                                iconColor: Color.warmRed
                            )
                            
                            ProgressCard(
                                title: "Achievements",
                                value: "\(appViewModel.userProgress.unlockedAchievements.count)/\(appViewModel.achievements.count)",
                                iconName: "trophy.fill",
                                iconColor: Color.orangeAccent
                            )
                        }
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 40)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)
                        

                        // Reset Section
                        SettingsSection(title: "Reset") {
                            Button(action: {
                                appViewModel.resetOnboarding()
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: UIConstants.iconSizeMedium))
                                        .foregroundColor(Color.warmRed)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Reset Onboarding")
                                            .font(Typography.cardTitle)
                                            .foregroundColor(Color.darkGray)
                                        
                                        Text("Show the welcome screens again")
                                            .font(Typography.cardSubtitle)
                                            .foregroundColor(Color.darkGray.opacity(0.7))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(Spacing.medium)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showContent)
                    }
                }
                .padding(.horizontal, Spacing.safeAreaPadding)
                .padding(.vertical, Spacing.medium)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
        }
    }
}

struct SettingsHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Customize Your Experience")
                        .font(Typography.sectionHeader)
                        .foregroundColor(Color.darkGray)
                    
                    Text("Adjust settings to match your preferences and track your progress.")
                        .font(Typography.bodyText)
                        .foregroundColor(Color.darkGray.opacity(0.7))
                        .lineLimit(nil)
                }
                
                Spacer()
            }
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text(title)
                .font(Typography.sectionHeader)
                .foregroundColor(Color.darkGray)
                .padding(.horizontal, Spacing.safeAreaPadding)
            
            VStack(spacing: 0) {
                content
            }
            .cardStyle()
        }
    }
}

struct SettingsToggle: View {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: Color
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: UIConstants.iconSizeMedium))
                .foregroundColor(iconColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Typography.cardTitle)
                    .foregroundColor(Color.darkGray)
                
                Text(subtitle)
                    .font(Typography.cardSubtitle)
                    .foregroundColor(Color.darkGray.opacity(0.7))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: iconColor))
                .scaleEffect(0.8)
        }
        .padding(Spacing.medium)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
        }
    }
}

struct ProgressCard: View {
    let title: String
    let value: String
    let iconName: String
    let iconColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: UIConstants.iconSizeMedium))
                .foregroundColor(iconColor)
                .frame(width: 30)
            
            Text(title)
                .font(Typography.cardTitle)
                .foregroundColor(Color.darkGray)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(iconColor)
        }
        .padding(Spacing.medium)
    }
}



#Preview {
    NavigationView {
        SettingsView(appViewModel: AppViewModel())
    }
}