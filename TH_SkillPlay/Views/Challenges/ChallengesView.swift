//
//  ChallengesView.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import SwiftUI

struct ChallengesView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var challengesViewModel = ChallengesViewModel()
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color.lightGray
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.large) {
                    // Header
                    ChallengesHeaderView()
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                    
                    // Daily Challenge Card
                    if let challenge = challengesViewModel.dailyChallenge {
                        DailyChallengeDetailCard(
                            challenge: challenge,
                            onProgressUpdate: { progress in
                                challengesViewModel.updateProgress(progress)
                                if progress >= challenge.targetValue {
                                    appViewModel.userProgress.completeChallenge(challenge)
                                }
                            }
                        )
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showContent)
                    }
                    
                    // Progress Summary
                    ProgressSummaryCard(userProgress: appViewModel.userProgress)
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 40)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)
                }
                .padding(.horizontal, Spacing.safeAreaPadding)
                .padding(.vertical, Spacing.medium)
            }
            
            // Confetti Overlay
            if challengesViewModel.showingConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
                    .transition(.opacity)
            }
        }
        .navigationTitle("Daily Challenges")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
        }
    }
}

struct ChallengesHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Challenge Yourself")
                        .font(Typography.sectionHeader)
                        .foregroundColor(Color.darkGray)
                    
                    Text("Complete daily challenges to build positive habits and earn rewards.")
                        .font(Typography.bodyText)
                        .foregroundColor(Color.darkGray.opacity(0.7))
                        .lineLimit(nil)
                }
                
                Spacer()
            }
        }
    }
}

struct DailyChallengeDetailCard: View {
    let challenge: DailyChallenge
    let onProgressUpdate: (Int) -> Void
    @State private var inputProgress = ""
    @State private var showingInput = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            // Header
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.orangeAccent.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: challenge.iconName)
                        .font(.system(size: UIConstants.iconSizeLarge))
                        .foregroundColor(Color.orangeAccent)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(challenge.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.darkGray)
                    
                    Text("Today's Challenge")
                        .font(Typography.caption)
                        .foregroundColor(Color.orangeAccent)
                        .padding(.horizontal, Spacing.small)
                        .padding(.vertical, 2)
                        .background(Color.orangeAccent.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                if challenge.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: UIConstants.iconSizeLarge))
                        .foregroundColor(Color.grassGreen)
                        .scaleEffect(1.2)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: challenge.isCompleted)
                }
            }
            
            // Description
            Text(challenge.description)
                .font(Typography.bodyText)
                .foregroundColor(Color.darkGray.opacity(0.8))
                .lineLimit(nil)
            
            // Progress Section
            VStack(alignment: .leading, spacing: Spacing.medium) {
                HStack {
                    Text("Progress")
                        .font(Typography.cardTitle)
                        .foregroundColor(Color.darkGray)
                    
                    Spacer()
                    
                    Text("\(challenge.currentProgress)/\(challenge.targetValue) \(challenge.unit)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.orangeAccent)
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.lightGray)
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orangeAccent)
                            .frame(width: geometry.size.width * challenge.progressPercentage, height: 12)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: challenge.progressPercentage)
                    }
                }
                .frame(height: 12)
                
                // Progress Percentage
                HStack {
                    Text("\(Int(challenge.progressPercentage * 100))% Complete")
                        .font(Typography.caption)
                        .foregroundColor(Color.darkGray.opacity(0.7))
                    
                    Spacer()
                }
            }
            
            // Action Buttons
            if !challenge.isCompleted {
                VStack(spacing: Spacing.medium) {
                    if showingInput {
                        HStack {
                            TextField("Enter progress", text: $inputProgress)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            Button("Update") {
                                if let progress = Int(inputProgress) {
                                    onProgressUpdate(progress)
                                    inputProgress = ""
                                    withAnimation(.spring()) {
                                        showingInput = false
                                    }
                                }
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .frame(width: 80)
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    HStack(spacing: Spacing.medium) {
                        Button(showingInput ? "Cancel" : "Update Progress") {
                            withAnimation(.spring()) {
                                showingInput.toggle()
                            }
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        Button("Complete Challenge") {
                            onProgressUpdate(challenge.targetValue)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
            } else {
                HStack {
                    Image(systemName: "party.popper.fill")
                        .font(.system(size: UIConstants.iconSizeMedium))
                        .foregroundColor(Color.grassGreen)
                    
                    Text("Challenge Completed! Great job!")
                        .font(Typography.buttonText)
                        .foregroundColor(Color.grassGreen)
                }
                .frame(maxWidth: .infinity)
                .frame(height: UIConstants.buttonHeight)
                .background(Color.grassGreen.opacity(0.1))
                .cornerRadius(UIConstants.buttonCornerRadius)
            }
        }
        .padding(Spacing.medium)
        .cardStyle()
    }
}

struct ProgressSummaryCard: View {
    let userProgress: UserProgress
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: UIConstants.iconSizeMedium))
                    .foregroundColor(Color.skyBlue)
                
                Text("Your Progress Summary")
                    .font(Typography.sectionHeader)
                    .foregroundColor(Color.darkGray)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.medium) {
                ProgressMetric(
                    title: "Total Points",
                    value: "\(userProgress.totalPoints)",
                    iconName: "star.fill",
                    color: Color.primaryYellow
                )
                
                ProgressMetric(
                    title: "Current Streak",
                    value: "\(userProgress.currentStreak)",
                    iconName: "flame.fill",
                    color: Color.warmRed
                )
                
                ProgressMetric(
                    title: "Completed Challenges",
                    value: "\(userProgress.completedChallenges.count)",
                    iconName: "checkmark.circle.fill",
                    color: Color.grassGreen
                )
                
                ProgressMetric(
                    title: "Achievements",
                    value: "\(userProgress.unlockedAchievements.count)",
                    iconName: "trophy.fill",
                    color: Color.orangeAccent
                )
            }
        }
        .padding(Spacing.medium)
        .cardStyle()
    }
}

struct ProgressMetric: View {
    let title: String
    let value: String
    let iconName: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.small) {
            Image(systemName: iconName)
                .font(.system(size: UIConstants.iconSizeLarge))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.darkGray)
            
            Text(title)
                .font(Typography.caption)
                .foregroundColor(Color.darkGray.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.medium)
        .background(color.opacity(0.1))
        .cornerRadius(UIConstants.cardCornerRadius)
    }
}

struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece()
                    .offset(
                        x: animate ? CGFloat.random(in: -200...200) : 0,
                        y: animate ? CGFloat.random(in: -400...400) : -100
                    )
                    .rotationEffect(.degrees(animate ? Double.random(in: 0...360) : 0))
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 3)
                        .delay(Double.random(in: 0...0.5)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    let colors: [Color] = [.primaryYellow, .orangeAccent, .warmRed, .grassGreen, .skyBlue]
    
    var body: some View {
        Rectangle()
            .fill(colors.randomElement() ?? .primaryYellow)
            .frame(width: 8, height: 8)
            .cornerRadius(2)
    }
}

#Preview {
    NavigationView {
        ChallengesView(appViewModel: AppViewModel())
    }
}