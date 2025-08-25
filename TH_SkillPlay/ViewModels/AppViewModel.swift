//
//  AppViewModel.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var settings = AppSettings()
    @Published var userProgress = UserProgress()
    @Published var currentView: AppView = .onboarding
    
    private let dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // Data
    @Published var onboardingSlides: [OnboardingSlide] = []
    @Published var learningCards: [LearningCard] = []
    @Published var lifestyleTips: [LifestyleTip] = []
    @Published var dailyChallenge: DailyChallenge?
    @Published var achievements: [Achievement] = []
    
    enum AppView {
        case onboarding
        case main
    }
    
    init() {
        loadData()
        setupBindings()
        checkOnboardingStatus()
    }
    
    private func loadData() {
        onboardingSlides = dataService.getOnboardingSlides()
        learningCards = dataService.getLearningCards()
        lifestyleTips = dataService.getLifestyleTips()
        dailyChallenge = dataService.getDailyChallenge()
        achievements = dataService.getAchievements()
    }
    
    private func setupBindings() {
        // Monitor settings changes
        settings.$hasCompletedOnboarding
            .sink { [weak self] hasCompleted in
                if hasCompleted {
                    self?.currentView = .main
                }
            }
            .store(in: &cancellables)
    }
    
    private func checkOnboardingStatus() {
        // In a real app, this would check UserDefaults or other persistent storage
        if settings.hasCompletedOnboarding {
            currentView = .main
        }
    }
    
    func completeOnboarding() {
        withAnimation(.spring()) {
            settings.hasCompletedOnboarding = true
            currentView = .main
        }
    }
    
    func resetOnboarding() {
        settings.hasCompletedOnboarding = false
        currentView = .onboarding
    }
}

// MARK: - Game ViewModel
class GameViewModel: ObservableObject {
    @Published var currentScore: Int = 0
    @Published var highScore: Int = 0
    @Published var gameState: GameState = .waiting
    @Published var timeRemaining: Int = 30
    @Published var gameType: GameType = .tapChallenge
    
    private var timer: Timer?
    
    enum GameState {
        case waiting
        case playing
        case finished
    }
    
    func startGame() {
        gameState = .playing
        currentScore = 0
        timeRemaining = 30
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.endGame()
            }
        }
    }
    
    func endGame() {
        timer?.invalidate()
        timer = nil
        gameState = .finished
        
        if currentScore > highScore {
            highScore = currentScore
        }
    }
    
    func tap() {
        guard gameState == .playing else { return }
        currentScore += 1
    }
    
    func resetGame() {
        gameState = .waiting
        currentScore = 0
        timeRemaining = 30
    }
}

// MARK: - Education ViewModel
class EducationViewModel: ObservableObject {
    @Published var learningCards: [LearningCard] = []
    @Published var selectedCard: LearningCard?
    @Published var showingDetail = false
    
    private let dataService = DataService.shared
    
    init() {
        loadLearningCards()
    }
    
    private func loadLearningCards() {
        learningCards = dataService.getLearningCards()
    }
    
    func selectCard(_ card: LearningCard) {
        selectedCard = card
        showingDetail = true
    }
    
    func markCardAsCompleted(_ card: LearningCard) {
        if let index = learningCards.firstIndex(where: { $0.id == card.id }) {
            learningCards[index] = LearningCard(
                title: card.title,
                description: card.description,
                content: card.content,
                category: card.category,
                estimatedReadTime: card.estimatedReadTime,
                iconName: card.iconName,
                isCompleted: true
            )
        }
    }
}

// MARK: - Lifestyle ViewModel
class LifestyleViewModel: ObservableObject {
    @Published var lifestyleTips: [LifestyleTip] = []
    @Published var filteredTips: [LifestyleTip] = []
    @Published var selectedCategory: LifestyleTipCategory?
    
    private let dataService = DataService.shared
    
    init() {
        loadLifestyleTips()
    }
    
    private func loadLifestyleTips() {
        lifestyleTips = dataService.getLifestyleTips()
        filteredTips = lifestyleTips
    }
    

    
    func filterTips(by category: LifestyleTipCategory?) {
        selectedCategory = category
        
        if let category = category {
            filteredTips = lifestyleTips.filter { $0.category == category }
        } else {
            filteredTips = lifestyleTips
        }
    }
    
    func markTipAsRead(_ tip: LifestyleTip) {
        if let index = lifestyleTips.firstIndex(where: { $0.id == tip.id }) {
            lifestyleTips[index] = LifestyleTip(
                title: tip.title,
                description: tip.description,
                category: tip.category,
                iconName: tip.iconName,
                isRead: true
            )
        }
        // Update filtered tips as well
        if let filteredIndex = filteredTips.firstIndex(where: { $0.id == tip.id }) {
            filteredTips[filteredIndex] = LifestyleTip(
                title: tip.title,
                description: tip.description,
                category: tip.category,
                iconName: tip.iconName,
                isRead: true
            )
        }
    }
}

// MARK: - Challenges ViewModel
class ChallengesViewModel: ObservableObject {
    @Published var dailyChallenge: DailyChallenge?
    @Published var showingConfetti = false
    
    private let dataService = DataService.shared
    
    init() {
        loadDailyChallenge()
    }
    
    private func loadDailyChallenge() {
        dailyChallenge = dataService.getDailyChallenge()
    }
    
    func updateProgress(_ progress: Int) {
        guard let challenge = dailyChallenge else { return }
        
        let updatedChallenge = DailyChallenge(
            title: challenge.title,
            description: challenge.description,
            targetValue: challenge.targetValue,
            currentProgress: min(progress, challenge.targetValue),
            unit: challenge.unit,
            iconName: challenge.iconName,
            date: challenge.date,
            isCompleted: progress >= challenge.targetValue
        )
        
        dailyChallenge = updatedChallenge
        
        if updatedChallenge.isCompleted && !challenge.isCompleted {
            triggerConfetti()
        }
    }
    
    private func triggerConfetti() {
        showingConfetti = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showingConfetti = false
        }
    }
}

// MARK: - Achievements ViewModel
class AchievementsViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var unlockedAchievements: Set<UUID> = []
    @Published var showingUnlockAnimation = false
    @Published var recentlyUnlockedAchievement: Achievement?
    
    private let dataService = DataService.shared
    
    init() {
        loadAchievements()
    }
    
    private func loadAchievements() {
        achievements = dataService.getAchievements()
    }
    
    func unlockAchievement(_ achievement: Achievement) {
        guard !unlockedAchievements.contains(achievement.id) else { return }
        
        unlockedAchievements.insert(achievement.id)
        recentlyUnlockedAchievement = achievement
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            showingUnlockAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.showingUnlockAnimation = false
            }
        }
    }
    
    func checkAndUnlockAchievements(userProgress: UserProgress) {
        // Check various achievement conditions
        
        // First Steps
        if !userProgress.completedChallenges.isEmpty {
            if let achievement = achievements.first(where: { $0.title == "First Steps" }) {
                unlockAchievement(achievement)
            }
        }
        
        // Knowledge Seeker
        if userProgress.completedLearningCards.count >= 5 {
            if let achievement = achievements.first(where: { $0.title == "Knowledge Seeker" }) {
                unlockAchievement(achievement)
            }
        }
        
        // Wellness Warrior
        if userProgress.readLifestyleTips.count >= 10 {
            if let achievement = achievements.first(where: { $0.title == "Wellness Warrior" }) {
                unlockAchievement(achievement)
            }
        }
        
        // Add more achievement checks as needed
    }
}