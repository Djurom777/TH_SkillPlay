//
//  MainMenuView.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import SwiftUI

struct MainMenuView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var selectedTab: AppCategory?
    @State private var showCategories = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightGray
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.large) {
                        // Header Section
                        HeaderSection(userProgress: appViewModel.userProgress)
                            .opacity(showCategories ? 1.0 : 0.0)
                            .offset(y: showCategories ? 0 : -20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showCategories)
                        
                        // Categories Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: Spacing.medium),
                            GridItem(.flexible(), spacing: Spacing.medium)
                        ], spacing: Spacing.medium) {
                            ForEach(Array(AppCategory.allCases.enumerated()), id: \.element) { index, category in
                                CategoryCard(
                                    category: category,
                                    isSelected: selectedTab == category
                                ) {
                                    selectedTab = category
                                }
                                .opacity(showCategories ? 1.0 : 0.0)
                                .offset(y: showCategories ? 0 : 30)
                                .animation(
                                    AnimationHelpers.staggeredAnimation(index: index, delay: 0.15),
                                    value: showCategories
                                )
                            }
                        }
                        .padding(.horizontal, Spacing.safeAreaPadding)
                        
                        // Daily Challenge Section
                        if let challenge = appViewModel.dailyChallenge {
                            NavigationLink(destination: ChallengesView(appViewModel: appViewModel)) {
                                DailyChallengeCard(challenge: challenge)
                                    .padding(.horizontal, Spacing.safeAreaPadding)
                                    .opacity(showCategories ? 1.0 : 0.0)
                                    .offset(y: showCategories ? 0 : 40)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: showCategories)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Recent Achievements
                        NavigationLink(destination: AchievementsView(appViewModel: appViewModel)) {
                            RecentAchievementsSection(achievements: appViewModel.achievements.prefix(3).map { $0 })
                                .padding(.horizontal, Spacing.safeAreaPadding)
                                .opacity(showCategories ? 1.0 : 0.0)
                                .offset(y: showCategories ? 0 : 50)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: showCategories)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, Spacing.medium)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("SkillPlay Life")
                        .font(Typography.navigationTitle)
                        .foregroundColor(Color.darkGray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView(appViewModel: appViewModel)) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: UIConstants.iconSizeMedium))
                            .foregroundColor(Color.darkGray)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showCategories = true
            }
        }
        .sheet(item: Binding<AppCategory?>(
            get: { selectedTab },
            set: { selectedTab = $0 }
        )) { category in
            CategoryDetailView(category: category, appViewModel: appViewModel)
        }
    }
}

struct HeaderSection: View {
    let userProgress: UserProgress
    
    var body: some View {
        VStack(spacing: Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Welcome back!")
                        .font(Typography.sectionHeader)
                        .foregroundColor(Color.darkGray)
                    
                    Text("Ready to learn and grow?")
                        .font(Typography.bodyText)
                        .foregroundColor(Color.darkGray.opacity(0.7))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: Spacing.xs) {
                    Text("\(userProgress.totalPoints)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.primaryYellow)
                    
                    Text("points")
                        .font(Typography.caption)
                        .foregroundColor(Color.darkGray.opacity(0.6))
                }
            }
            .padding(.horizontal, Spacing.safeAreaPadding)
        }
    }
}

struct CategoryCard: View {
    let category: AppCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.medium) {
                ZStack {
                    Circle()
                        .fill(category.backgroundColor)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.systemImageName)
                        .font(.system(size: UIConstants.iconSizeLarge, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text(category.rawValue)
                    .font(Typography.cardTitle)
                    .foregroundColor(Color.darkGray)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .cardStyle()
            .scaleEffect(isSelected ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DailyChallengeCard: View {
    let challenge: DailyChallenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: UIConstants.iconSizeMedium))
                    .foregroundColor(Color.orangeAccent)
                
                Text("Today's Challenge")
                    .font(Typography.sectionHeader)
                    .foregroundColor(Color.darkGray)
                
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: Spacing.small) {
                    Text(challenge.title)
                        .font(Typography.cardTitle)
                        .foregroundColor(Color.darkGray)
                    
                    Text(challenge.description)
                        .font(Typography.cardSubtitle)
                        .foregroundColor(Color.darkGray.opacity(0.7))
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.lightGray, lineWidth: 4)
                        .frame(width: 50, height: 50)
                    
                    Circle()
                        .trim(from: 0, to: challenge.progressPercentage)
                        .stroke(Color.grassGreen, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(challenge.progressPercentage * 100))%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color.darkGray)
                }
            }
        }
        .padding(Spacing.medium)
        .cardStyle()
    }
}

struct RecentAchievementsSection: View {
    let achievements: [Achievement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack {
                Image(systemName: "trophy.fill")
                    .font(.system(size: UIConstants.iconSizeMedium))
                    .foregroundColor(Color.primaryYellow)
                
                Text("Recent Achievements")
                    .font(Typography.sectionHeader)
                    .foregroundColor(Color.darkGray)
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.medium) {
                    ForEach(achievements) { achievement in
                        AchievementBadge(achievement: achievement, isUnlocked: false)
                    }
                }
                .padding(.horizontal, Spacing.safeAreaPadding)
            }
        }
    }
}

struct AchievementBadge: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: Spacing.small) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? achievement.rarity.color : Color.lightGray)
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.iconName)
                    .font(.system(size: UIConstants.iconSizeMedium))
                    .foregroundColor(isUnlocked ? .white : Color.darkGray.opacity(0.5))
            }
            
            Text(achievement.title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color.darkGray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 60)
        }
    }
}

// MARK: - Category Detail View
struct CategoryDetailView: View {
    let category: AppCategory
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Group {
                switch category {
                case .education:
                    EducationView(appViewModel: appViewModel)
                case .games:
                    GamesView(appViewModel: appViewModel)
                case .lifestyle:
                    LifestyleView(appViewModel: appViewModel)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.primaryYellow)
                }
            }
        }
    }
}

#Preview {
    MainMenuView(appViewModel: AppViewModel())
}