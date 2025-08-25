//
//  GamesView.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import SwiftUI

struct GamesView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var gameViewModel = GameViewModel()
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color.lightGray
                .ignoresSafeArea()
            
            VStack(spacing: Spacing.large) {
                // Header
                GameHeaderView(gameViewModel: gameViewModel)
                    .opacity(showContent ? 1.0 : 0.0)
                    .offset(y: showContent ? 0 : -20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                
                Spacer()
                
                // Game Content
                GameContentView(gameViewModel: gameViewModel, appViewModel: appViewModel)
                    .opacity(showContent ? 1.0 : 0.0)
                    .scaleEffect(showContent ? 1.0 : 0.9)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showContent)
                
                Spacer()
                
                // Game Controls
                GameControlsView(gameViewModel: gameViewModel)
                    .opacity(showContent ? 1.0 : 0.0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)
            }
            .padding(.horizontal, Spacing.safeAreaPadding)
            .padding(.vertical, Spacing.medium)
        }
        .navigationTitle("Mini Games")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
        }
    }
}

struct GameHeaderView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Tap Challenge")
                        .font(Typography.sectionHeader)
                        .foregroundColor(Color.darkGray)
                    
                    Text("Test your speed and reflexes!")
                        .font(Typography.bodyText)
                        .foregroundColor(Color.darkGray.opacity(0.7))
                }
                
                Spacer()
            }
            
            // Score Display
            HStack(spacing: Spacing.xl) {
                ScoreCard(title: "Current Score", score: gameViewModel.currentScore, color: Color.orangeAccent)
                ScoreCard(title: "High Score", score: gameViewModel.highScore, color: Color.primaryYellow)
            }
        }
    }
}

struct ScoreCard: View {
    let title: String
    let score: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.small) {
            Text(title)
                .font(Typography.caption)
                .foregroundColor(Color.darkGray.opacity(0.7))
            
            Text("\(score)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.medium)
        .cardStyle()
    }
}

struct GameContentView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var appViewModel: AppViewModel
    @State private var tapScale: CGFloat = 1.0
    @State private var showTapEffect = false
    
    var body: some View {
        VStack(spacing: Spacing.large) {
            // Timer
            if gameViewModel.gameState == .playing {
                TimerView(timeRemaining: gameViewModel.timeRemaining)
                    .transition(.scale.combined(with: .opacity))
            }
            
            // Game Area
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(height: 300)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                // Game State Content
                Group {
                    switch gameViewModel.gameState {
                    case .waiting:
                        WaitingStateView()
                    case .playing:
                        PlayingStateView(
                            tapScale: $tapScale,
                            showTapEffect: $showTapEffect,
                            onTap: {
                                gameViewModel.tap()
                                triggerTapAnimation()
                            }
                        )
                    case .finished:
                        FinishedStateView(
                            score: gameViewModel.currentScore,
                            isNewHighScore: gameViewModel.currentScore == gameViewModel.highScore
                        ) {
                            // Save score to app view model
                            let gameScore = GameScore(
                                score: gameViewModel.currentScore,
                                date: Date(),
                                gameType: .tapChallenge
                            )
                            appViewModel.userProgress.addGameScore(gameScore)
                        }
                    }
                }
            }
        }
    }
    
    private func triggerTapAnimation() {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
            tapScale = 1.2
            showTapEffect = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                tapScale = 1.0
                showTapEffect = false
            }
        }
    }
}

struct TimerView: View {
    let timeRemaining: Int
    
    var body: some View {
        HStack(spacing: Spacing.small) {
            Image(systemName: "timer")
                .font(.system(size: UIConstants.iconSizeMedium))
                .foregroundColor(Color.orangeAccent)
            
            Text("\(timeRemaining)s")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(timeRemaining <= 5 ? Color.warmRed : Color.darkGray)
                .animation(.easeInOut(duration: 0.3), value: timeRemaining)
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(Color.lightGray)
        .cornerRadius(20)
    }
}

struct WaitingStateView: View {
    var body: some View {
        VStack(spacing: Spacing.large) {
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 60))
                .foregroundColor(Color.orangeAccent)
            
            VStack(spacing: Spacing.small) {
                Text("Tap Challenge")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.darkGray)
                
                Text("Tap as fast as you can for 30 seconds!")
                    .font(Typography.bodyText)
                    .foregroundColor(Color.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct PlayingStateView: View {
    @Binding var tapScale: CGFloat
    @Binding var showTapEffect: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(Color.orangeAccent)
                    .frame(width: 120, height: 120)
                    .scaleEffect(tapScale)
                
                if showTapEffect {
                    Circle()
                        .stroke(Color.orangeAccent.opacity(0.5), lineWidth: 4)
                        .frame(width: 140, height: 140)
                        .scaleEffect(showTapEffect ? 1.5 : 1.0)
                        .opacity(showTapEffect ? 0.0 : 1.0)
                        .animation(.easeOut(duration: 0.3), value: showTapEffect)
                }
                
                Text("TAP!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FinishedStateView: View {
    let score: Int
    let isNewHighScore: Bool
    let onScoreSaved: () -> Void
    @State private var showCelebration = false
    
    var body: some View {
        VStack(spacing: Spacing.large) {
            // Trophy or Star
            Image(systemName: isNewHighScore ? "trophy.fill" : "star.fill")
                .font(.system(size: 60))
                .foregroundColor(isNewHighScore ? Color.primaryYellow : Color.orangeAccent)
                .scaleEffect(showCelebration ? 1.2 : 1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: showCelebration)
            
            VStack(spacing: Spacing.small) {
                Text(isNewHighScore ? "New High Score!" : "Game Over!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.darkGray)
                
                Text("You scored \(score) points")
                    .font(Typography.bodyText)
                    .foregroundColor(Color.darkGray.opacity(0.7))
                
                if isNewHighScore {
                    Text("🎉 Amazing! 🎉")
                        .font(Typography.bodyText)
                        .foregroundColor(Color.primaryYellow)
                        .scaleEffect(showCelebration ? 1.1 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6).repeatCount(3), value: showCelebration)
                }
            }
        }
        .onAppear {
            onScoreSaved()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                showCelebration = true
            }
        }
    }
}

struct GameControlsView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: Spacing.medium) {
            switch gameViewModel.gameState {
            case .waiting:
                Button("Start Game") {
                    gameViewModel.startGame()
                }
                .buttonStyle(PrimaryButtonStyle())
                
            case .playing:
                Button("Stop Game") {
                    gameViewModel.endGame()
                }
                .buttonStyle(SecondaryButtonStyle())
                
            case .finished:
                Button("Play Again") {
                    gameViewModel.resetGame()
                }
                .buttonStyle(PrimaryButtonStyle())
                .scaleEffect(1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: gameViewModel.gameState)
            }
        }
    }
}

#Preview {
    GamesView(appViewModel: AppViewModel())
}