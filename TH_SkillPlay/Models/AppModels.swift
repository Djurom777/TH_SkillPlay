//
//  AppModels.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import Foundation
import SwiftUI

// MARK: - Onboarding
struct OnboardingSlide: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImageName: String
    let backgroundColor: String
    let iconColor: String
}

// MARK: - Main Categories
enum AppCategory: String, CaseIterable, Identifiable {
    case education = "Education"
    case games = "Games"
    case lifestyle = "Lifestyle"
    
    var id: String { rawValue }
    
    var systemImageName: String {
        switch self {
        case .education:
            return "book.fill"
        case .games:
            return "gamecontroller.fill"
        case .lifestyle:
            return "heart.fill"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .education:
            return Color.skyBlue
        case .games:
            return Color.orangeAccent
        case .lifestyle:
            return Color.grassGreen
        }
    }
}

// MARK: - Education Content
struct LearningCard: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let content: String
    let category: String
    let estimatedReadTime: Int // in minutes
    let iconName: String
    let isCompleted: Bool
    
    init(title: String, description: String, content: String, category: String, estimatedReadTime: Int, iconName: String, isCompleted: Bool = false) {
        self.title = title
        self.description = description
        self.content = content
        self.category = category
        self.estimatedReadTime = estimatedReadTime
        self.iconName = iconName
        self.isCompleted = isCompleted
    }
}

// MARK: - Games
struct GameScore: Codable {
    let score: Int
    let date: Date
    let gameType: GameType
}

enum GameType: String, CaseIterable, Codable {
    case tapChallenge = "Tap Challenge"
    case memoryGame = "Memory Game"
    case reactionTime = "Reaction Time"
    
    var description: String {
        switch self {
        case .tapChallenge:
            return "Tap as fast as you can!"
        case .memoryGame:
            return "Remember the sequence"
        case .reactionTime:
            return "Test your reflexes"
        }
    }
    
    var iconName: String {
        switch self {
        case .tapChallenge:
            return "hand.tap.fill"
        case .memoryGame:
            return "brain.head.profile"
        case .reactionTime:
            return "timer"
        }
    }
}

// MARK: - Lifestyle Tips
struct LifestyleTip: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: LifestyleTipCategory
    let iconName: String
    let isRead: Bool
    
    init(title: String, description: String, category: LifestyleTipCategory, iconName: String, isRead: Bool = false) {
        self.title = title
        self.description = description
        self.category = category
        self.iconName = iconName
        self.isRead = isRead
    }
}

enum LifestyleTipCategory: String, CaseIterable {
    case health = "Health"
    case productivity = "Productivity"
    case mindfulness = "Mindfulness"
    case fitness = "Fitness"
    
    var color: Color {
        switch self {
        case .health:
            return Color.warmRed
        case .productivity:
            return Color.orangeAccent
        case .mindfulness:
            return Color.skyBlue
        case .fitness:
            return Color.grassGreen
        }
    }
}

// MARK: - Daily Challenges
struct DailyChallenge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let targetValue: Int
    let currentProgress: Int
    let unit: String
    let iconName: String
    let date: Date
    let isCompleted: Bool
    
    var progressPercentage: Double {
        guard targetValue > 0 else { return 0 }
        return min(Double(currentProgress) / Double(targetValue), 1.0)
    }
    
    init(title: String, description: String, targetValue: Int, currentProgress: Int = 0, unit: String, iconName: String, date: Date = Date(), isCompleted: Bool = false) {
        self.title = title
        self.description = description
        self.targetValue = targetValue
        self.currentProgress = currentProgress
        self.unit = unit
        self.iconName = iconName
        self.date = date
        self.isCompleted = isCompleted
    }
}

// MARK: - Achievements
struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let isUnlocked: Bool
    let unlockedDate: Date?
    let category: AchievementCategory
    let rarity: AchievementRarity
    
    init(title: String, description: String, iconName: String, isUnlocked: Bool = false, unlockedDate: Date? = nil, category: AchievementCategory, rarity: AchievementRarity) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.isUnlocked = isUnlocked
        self.unlockedDate = unlockedDate
        self.category = category
        self.rarity = rarity
    }
}

enum AchievementCategory: String, CaseIterable {
    case education = "Education"
    case games = "Games"
    case lifestyle = "Lifestyle"
    case challenges = "Challenges"
}

enum AchievementRarity: String, CaseIterable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    
    var color: Color {
        switch self {
        case .common:
            return Color.lightGray
        case .rare:
            return Color.skyBlue
        case .epic:
            return Color.orangeAccent
        case .legendary:
            return Color.primaryYellow
        }
    }
}

// MARK: - App Settings
class AppSettings: ObservableObject {
    @Published var animationsEnabled: Bool = true {
        didSet { UserDefaults.standard.set(animationsEnabled, forKey: "animationsEnabled") }
    }
    @Published var notificationsEnabled: Bool = true {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled") }
    }
    @Published var hasCompletedOnboarding: Bool = false {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding") }
    }
    
    init() {
        loadFromUserDefaults()
    }
    
    private func loadFromUserDefaults() {
        // Set defaults if this is first launch
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            UserDefaults.standard.set(true, forKey: "animationsEnabled")
            UserDefaults.standard.set(true, forKey: "notificationsEnabled")
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
        
        animationsEnabled = UserDefaults.standard.bool(forKey: "animationsEnabled") 
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
}

// MARK: - User Progress
class UserProgress: ObservableObject {
    private var isLoading = false
    
    @Published var completedLearningCards: Set<UUID> = [] {
        didSet { 
            if !isLoading { saveToUserDefaults() }
        }
    }
    @Published var gameScores: [GameScore] = [] {
        didSet { 
            if !isLoading { saveToUserDefaults() }
        }
    }
    @Published var readLifestyleTips: Set<UUID> = [] {
        didSet { 
            if !isLoading { saveToUserDefaults() }
        }
    }
    @Published var completedChallenges: Set<UUID> = [] {
        didSet { 
            if !isLoading { saveToUserDefaults() }
        }
    }
    @Published var unlockedAchievements: Set<UUID> = [] {
        didSet { 
            if !isLoading { saveToUserDefaults() }
        }
    }
    @Published var currentStreak: Int = 0 {
        didSet { 
            if !isLoading { saveToUserDefaults() }
        }
    }
    @Published var totalPoints: Int = 0 {
        didSet { 
            if !isLoading { saveToUserDefaults() }
        }
    }
    
    init() {
        loadFromUserDefaults()
    }
    
    func completeChallenge(_ challenge: DailyChallenge) {
        completedChallenges.insert(challenge.id)
        totalPoints += 50 // Award points for completing challenges
    }
    
    func completeEducationCard(_ card: LearningCard) {
        completedLearningCards.insert(card.id)
        totalPoints += 25 // Award points for education
    }
    
    func addGameScore(_ score: GameScore) {
        gameScores.append(score)
        totalPoints += score.score
    }
    
    func readLifestyleTip(_ tip: LifestyleTip) {
        readLifestyleTips.insert(tip.id)
        totalPoints += 10 // Award points for reading tips
    }
    
    func unlockAchievement(_ achievement: Achievement) {
        unlockedAchievements.insert(achievement.id)
        totalPoints += 100 // Bonus points for achievements
    }
    
    // MARK: - Persistence
    private func saveToUserDefaults() {
        let encoder = JSONEncoder()
        
        // Save completed learning cards
        if let completedCardsData = try? encoder.encode(Array(completedLearningCards)) {
            UserDefaults.standard.set(completedCardsData, forKey: "completedLearningCards")
        }
        
        // Save game scores
        if let gameScoresData = try? encoder.encode(gameScores) {
            UserDefaults.standard.set(gameScoresData, forKey: "gameScores")
        }
        
        // Save read lifestyle tips
        if let readTipsData = try? encoder.encode(Array(readLifestyleTips)) {
            UserDefaults.standard.set(readTipsData, forKey: "readLifestyleTips")
        }
        
        // Save completed challenges
        if let completedChallengesData = try? encoder.encode(Array(completedChallenges)) {
            UserDefaults.standard.set(completedChallengesData, forKey: "completedChallenges")
        }
        
        // Save unlocked achievements
        if let unlockedAchievementsData = try? encoder.encode(Array(unlockedAchievements)) {
            UserDefaults.standard.set(unlockedAchievementsData, forKey: "unlockedAchievements")
        }
        
        // Save simple values
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        UserDefaults.standard.set(totalPoints, forKey: "totalPoints")
    }
    
    private func loadFromUserDefaults() {
        isLoading = true
        let decoder = JSONDecoder()
        
        // Load completed learning cards
        if let completedCardsData = UserDefaults.standard.data(forKey: "completedLearningCards"),
           let completedCardsArray = try? decoder.decode([UUID].self, from: completedCardsData) {
            completedLearningCards = Set(completedCardsArray)
        }
        
        // Load game scores
        if let gameScoresData = UserDefaults.standard.data(forKey: "gameScores"),
           let gameScoresArray = try? decoder.decode([GameScore].self, from: gameScoresData) {
            gameScores = gameScoresArray
        }
        
        // Load read lifestyle tips
        if let readTipsData = UserDefaults.standard.data(forKey: "readLifestyleTips"),
           let readTipsArray = try? decoder.decode([UUID].self, from: readTipsData) {
            readLifestyleTips = Set(readTipsArray)
        }
        
        // Load completed challenges
        if let completedChallengesData = UserDefaults.standard.data(forKey: "completedChallenges"),
           let completedChallengesArray = try? decoder.decode([UUID].self, from: completedChallengesData) {
            completedChallenges = Set(completedChallengesArray)
        }
        
        // Load unlocked achievements
        if let unlockedAchievementsData = UserDefaults.standard.data(forKey: "unlockedAchievements"),
           let unlockedAchievementsArray = try? decoder.decode([UUID].self, from: unlockedAchievementsData) {
            unlockedAchievements = Set(unlockedAchievementsArray)
        }
        
        // Load simple values
        currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        totalPoints = UserDefaults.standard.integer(forKey: "totalPoints")
        
        isLoading = false
    }
}