//
//  AchievementsView.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var achievementsViewModel = AchievementsViewModel()
    @State private var showAchievements = false
    @State private var selectedFilter: AchievementCategory? = nil
    
    var filteredAchievements: [Achievement] {
        if let filter = selectedFilter {
            return achievementsViewModel.achievements.filter { $0.category == filter }
        }
        return achievementsViewModel.achievements
    }
    
    var body: some View {
        ZStack {
            Color.lightGray
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Filter Section
                AchievementFilterView(
                    selectedCategory: selectedFilter,
                    onCategorySelected: { category in
                        selectedFilter = category
                    }
                )
                .opacity(showAchievements ? 1.0 : 0.0)
                .offset(y: showAchievements ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showAchievements)
                
                ScrollView {
                    VStack(spacing: Spacing.large) {
                        // Header
                        AchievementsHeaderView(
                            unlockedCount: achievementsViewModel.unlockedAchievements.count,
                            totalCount: achievementsViewModel.achievements.count
                        )
                        .opacity(showAchievements ? 1.0 : 0.0)
                        .offset(y: showAchievements ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showAchievements)
                        
                        // Achievements Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: Spacing.medium),
                            GridItem(.flexible(), spacing: Spacing.medium)
                        ], spacing: Spacing.medium) {
                            ForEach(Array(filteredAchievements.enumerated()), id: \.element.id) { index, achievement in
                                AchievementCard(
                                    achievement: achievement,
                                    isUnlocked: achievementsViewModel.unlockedAchievements.contains(achievement.id)
                                ) {
                                    achievementsViewModel.unlockAchievement(achievement)
                                }
                                .opacity(showAchievements ? 1.0 : 0.0)
                                .offset(y: showAchievements ? 0 : 30)
                                .scaleEffect(showAchievements ? 1.0 : 0.9)
                                .animation(
                                    AnimationHelpers.staggeredAnimation(index: index, delay: 0.08),
                                    value: showAchievements
                                )
                            }
                        }
                        .padding(.horizontal, Spacing.safeAreaPadding)
                    }
                    .padding(.vertical, Spacing.medium)
                }
            }
            
            // Unlock Animation Overlay
            if achievementsViewModel.showingUnlockAnimation,
               let recentAchievement = achievementsViewModel.recentlyUnlockedAchievement {
                AchievementUnlockOverlay(achievement: recentAchievement)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            achievementsViewModel.checkAndUnlockAchievements(userProgress: appViewModel.userProgress)
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showAchievements = true
            }
        }
    }
}

struct AchievementsHeaderView: View {
    let unlockedCount: Int
    let totalCount: Int
    
    var progressPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(unlockedCount) / Double(totalCount)
    }
    
    var body: some View {
        VStack(spacing: Spacing.large) {
            // Title and Description
            VStack(alignment: .leading, spacing: Spacing.medium) {
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Your Achievements")
                            .font(Typography.sectionHeader)
                            .foregroundColor(Color.darkGray)
                        
                        Text("Unlock badges by completing challenges and reaching milestones.")
                            .font(Typography.bodyText)
                            .foregroundColor(Color.darkGray.opacity(0.7))
                            .lineLimit(nil)
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, Spacing.safeAreaPadding)
            
            // Progress Card
            VStack(spacing: Spacing.medium) {
                HStack {
                    Text("Overall Progress")
                        .font(Typography.cardTitle)
                        .foregroundColor(Color.darkGray)
                    
                    Spacer()
                    
                    Text("\(unlockedCount)/\(totalCount)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.primaryYellow)
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.lightGray)
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.primaryYellow)
                            .frame(width: geometry.size.width * progressPercentage, height: 12)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progressPercentage)
                    }
                }
                .frame(height: 12)
                
                HStack {
                    Text("\(Int(progressPercentage * 100))% Complete")
                        .font(Typography.caption)
                        .foregroundColor(Color.darkGray.opacity(0.7))
                    
                    Spacer()
                }
            }
            .padding(Spacing.medium)
            .cardStyle()
            .padding(.horizontal, Spacing.safeAreaPadding)
        }
    }
}

struct AchievementFilterView: View {
    let selectedCategory: AchievementCategory?
    let onCategorySelected: (AchievementCategory?) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.small) {
                // All Categories Button
                FilterButton(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    color: Color.darkGray
                ) {
                    onCategorySelected(nil)
                }
                
                // Category Buttons
                ForEach(AchievementCategory.allCases, id: \.self) { category in
                    FilterButton(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        color: colorForCategory(category)
                    ) {
                        onCategorySelected(category)
                    }
                }
            }
            .padding(.horizontal, Spacing.safeAreaPadding)
        }
        .padding(.vertical, Spacing.small)
    }
    
    private func colorForCategory(_ category: AchievementCategory) -> Color {
        switch category {
        case .education:
            return Color.skyBlue
        case .games:
            return Color.orangeAccent
        case .lifestyle:
            return Color.grassGreen
        case .challenges:
            return Color.warmRed
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if !isUnlocked {
                onTap()
            }
        }) {
            VStack(spacing: Spacing.medium) {
                // Badge Icon
                ZStack {
                    Circle()
                        .fill(isUnlocked ? achievement.rarity.color : Color.lightGray)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(isUnlocked ? achievement.rarity.color.opacity(0.3) : Color.clear, lineWidth: 4)
                                .frame(width: 80, height: 80)
                                .blur(radius: isUnlocked ? 2 : 0)
                                .opacity(isUnlocked ? 0.8 : 0)
                        )
                    
                    Image(systemName: achievement.iconName)
                        .font(.system(size: UIConstants.iconSizeLarge, weight: .medium))
                        .foregroundColor(isUnlocked ? .white : Color.darkGray.opacity(0.4))
                    
                    if !isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color.darkGray.opacity(0.6))
                            .offset(x: 20, y: 20)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 24, height: 24)
                            )
                    }
                }
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
                
                // Achievement Info
                VStack(spacing: Spacing.xs) {
                    Text(achievement.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isUnlocked ? Color.darkGray : Color.darkGray.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(achievement.rarity.rawValue)
                        .font(Typography.caption)
                        .foregroundColor(isUnlocked ? achievement.rarity.color : Color.darkGray.opacity(0.4))
                        .padding(.horizontal, Spacing.xs)
                        .padding(.vertical, 1)
                        .background(
                            (isUnlocked ? achievement.rarity.color : Color.darkGray.opacity(0.2))
                                .opacity(0.1)
                        )
                        .cornerRadius(6)
                    
                    Text(achievement.description)
                        .font(.system(size: 12))
                        .foregroundColor(Color.darkGray.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(Spacing.medium)
            .cardStyle()
            .overlay(
                RoundedRectangle(cornerRadius: UIConstants.cardCornerRadius)
                    .stroke(
                        isUnlocked ? achievement.rarity.color.opacity(0.3) : Color.clear,
                        lineWidth: 2
                    )
            )
            .saturation(isUnlocked ? 1.0 : 0.3)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0) { pressing in
            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                isPressed = pressing
            }
        } perform: {}
    }
}

struct AchievementUnlockOverlay: View {
    let achievement: Achievement
    @State private var showContent = false
    @State private var showGlow = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    // Dismiss on tap
                }
            
            // Content
            VStack(spacing: Spacing.xl) {
                // Achievement Badge with Glow
                ZStack {
                    // Glow Effect
                    Circle()
                        .fill(achievement.rarity.color)
                        .frame(width: showGlow ? 140 : 100, height: showGlow ? 140 : 100)
                        .blur(radius: 20)
                        .opacity(showGlow ? 0.6 : 0.3)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: showGlow)
                    
                    // Main Badge
                    Circle()
                        .fill(achievement.rarity.color)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: achievement.iconName)
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.white)
                        )
                        .scaleEffect(showContent ? 1.0 : 0.5)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6), value: showContent)
                }
                
                // Text Content
                VStack(spacing: Spacing.medium) {
                    Text("Achievement Unlocked!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showContent)
                    
                    Text(achievement.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(achievement.rarity.color)
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: showContent)
                    
                    Text(achievement.description)
                        .font(Typography.bodyText)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.large)
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: showContent)
                    
                    Text(achievement.rarity.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, Spacing.medium)
                        .padding(.vertical, Spacing.xs)
                        .background(achievement.rarity.color)
                        .cornerRadius(16)
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: showContent)
                }
            }
            .padding(Spacing.xl)
        }
        .onAppear {
            withAnimation {
                showContent = true
                showGlow = true
            }
        }
    }
}

#Preview {
    NavigationView {
        AchievementsView(appViewModel: AppViewModel())
    }
}