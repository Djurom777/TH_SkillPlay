//
//  DataService.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import Foundation

class DataService: ObservableObject {
    static let shared = DataService()
    
    private init() {}
    
    // MARK: - Onboarding Data
    func getOnboardingSlides() -> [OnboardingSlide] {
        return [
            OnboardingSlide(
                title: "Welcome to SkillPlay Life",
                subtitle: "Discover a world of learning, gaming, and lifestyle improvement all in one place.",
                systemImageName: "star.fill",
                backgroundColor: "primaryYellow",
                iconColor: "white"
            ),
            OnboardingSlide(
                title: "Learn Something New",
                subtitle: "Explore educational content designed to expand your knowledge and skills.",
                systemImageName: "book.fill",
                backgroundColor: "skyBlue",
                iconColor: "white"
            ),
            OnboardingSlide(
                title: "Play & Challenge Yourself",
                subtitle: "Enjoy mini-games and daily challenges that keep your mind sharp and engaged.",
                systemImageName: "gamecontroller.fill",
                backgroundColor: "orangeAccent",
                iconColor: "white"
            ),
            OnboardingSlide(
                title: "Live Better Every Day",
                subtitle: "Get lifestyle tips and track your progress toward a healthier, happier you.",
                systemImageName: "heart.fill",
                backgroundColor: "grassGreen",
                iconColor: "white"
            )
        ]
    }
    
    // MARK: - Education Content
    func getLearningCards() -> [LearningCard] {
        return [
            LearningCard(
                title: "The Science of Habits",
                description: "Discover how habits form and learn strategies to build positive ones.",
                content: "Habits are the compound interest of self-improvement. The same way that money multiplies through compound interest, the effects of your habits multiply as you repeat them.\n\nThe habit loop consists of three parts:\n1. Cue - A trigger that initiates the behavior\n2. Routine - The behavior itself\n3. Reward - The benefit you gain from doing the behavior\n\nTo build good habits:\n- Start small (2-minute rule)\n- Stack habits on existing routines\n- Design your environment for success\n- Track your progress\n- Celebrate small wins\n\nRemember: You don't rise to the level of your goals, you fall to the level of your systems.",
                category: "Personal Development",
                estimatedReadTime: 3,
                iconName: "arrow.triangle.2.circlepath"
            ),
            LearningCard(
                title: "Mindful Breathing Techniques",
                description: "Learn simple breathing exercises to reduce stress and improve focus.",
                content: "Breathing is one of the few bodily functions that can be both automatic and consciously controlled. This makes it a powerful tool for managing stress and anxiety.\n\n4-7-8 Breathing Technique:\n1. Exhale completely through your mouth\n2. Close your mouth and inhale through your nose for 4 counts\n3. Hold your breath for 7 counts\n4. Exhale through your mouth for 8 counts\n5. Repeat 3-4 times\n\nBox Breathing (Navy SEAL technique):\n1. Inhale for 4 counts\n2. Hold for 4 counts\n3. Exhale for 4 counts\n4. Hold empty for 4 counts\n\nPractice these techniques daily, especially during stressful moments. Even 2-3 minutes can make a significant difference in your mental state.",
                category: "Wellness",
                estimatedReadTime: 2,
                iconName: "wind"
            ),
            LearningCard(
                title: "Time Management Mastery",
                description: "Effective strategies to manage your time and boost productivity.",
                content: "Time is our most valuable resource. Unlike money, we can't earn more time, so we must use it wisely.\n\nThe Eisenhower Matrix:\n- Urgent + Important: Do first\n- Important + Not Urgent: Schedule\n- Urgent + Not Important: Delegate\n- Not Urgent + Not Important: Eliminate\n\nTime Blocking:\n1. List all your tasks\n2. Estimate time needed for each\n3. Block specific times in your calendar\n4. Include buffer time for unexpected tasks\n5. Batch similar activities together\n\nThe Pomodoro Technique:\n- Work for 25 minutes\n- Take a 5-minute break\n- After 4 cycles, take a longer 15-30 minute break\n\nRemember: The goal isn't to be busy, it's to be productive.",
                category: "Productivity",
                estimatedReadTime: 4,
                iconName: "clock.fill"
            ),
            LearningCard(
                title: "The Power of Gratitude",
                description: "Understand how practicing gratitude can transform your mindset and life.",
                content: "Gratitude is not just a feel-good practice—it's scientifically proven to improve mental and physical health.\n\nBenefits of Gratitude:\n- Improves mood and life satisfaction\n- Enhances relationships\n- Boosts immune system\n- Improves sleep quality\n- Reduces stress and anxiety\n- Increases resilience\n\nSimple Gratitude Practices:\n1. Three Good Things: Each night, write down three things that went well\n2. Gratitude Letter: Write to someone who helped you\n3. Gratitude Walk: Notice and appreciate your surroundings\n4. Mental Subtraction: Imagine good things in your life never happened\n5. Gratitude Jar: Drop in notes of things you're grateful for\n\nStart with just one practice and do it consistently for 21 days. You'll be amazed at the positive changes in your perspective.",
                category: "Mindfulness",
                estimatedReadTime: 3,
                iconName: "heart.text.square.fill"
            ),
            LearningCard(
                title: "Growth Mindset vs Fixed Mindset",
                description: "Learn about different mindsets and how they impact your success.",
                content: "Your mindset—the beliefs you have about your abilities—can dramatically impact your success and happiness.\n\nFixed Mindset beliefs:\n- Intelligence and talent are static\n- Challenges are threats\n- Effort is a sign of weakness\n- Feedback is personal criticism\n- Others' success is threatening\n\nGrowth Mindset beliefs:\n- Intelligence and talent can be developed\n- Challenges are opportunities\n- Effort is the path to mastery\n- Feedback is valuable information\n- Others' success is inspiring\n\nDeveloping a Growth Mindset:\n1. Add 'yet' to your vocabulary ('I can't do this yet')\n2. View challenges as opportunities to learn\n3. Focus on the process, not just outcomes\n4. Learn from criticism and failures\n5. Be inspired by others' success\n\nRemember: Your brain is like a muscle—the more you use it, the stronger it gets.",
                category: "Psychology",
                estimatedReadTime: 4,
                iconName: "brain.head.profile"
            )
        ]
    }
    
    // MARK: - Lifestyle Tips
    func getLifestyleTips() -> [LifestyleTip] {
        return [
            LifestyleTip(
                title: "Start Your Day with Water",
                description: "Drink a glass of water first thing in the morning to kickstart your metabolism and rehydrate your body after hours of sleep. Your body loses water through breathing and sweating during the night, so morning hydration is crucial for optimal body function. This simple habit can boost energy levels, improve brain function, and help maintain healthy skin. Adding a slice of lemon can provide vitamin C and additional health benefits.",
                category: .health,
                iconName: "drop.fill"
            ),
            LifestyleTip(
                title: "The 2-Minute Rule",
                description: "If a task takes less than 2 minutes to complete, do it immediately rather than putting it off. This prevents small tasks from piling up and becoming overwhelming. The 2-minute rule is a powerful productivity technique that helps maintain a clean workspace and reduces mental clutter. Examples include responding to quick emails, filing documents, washing dishes immediately after use, or making your bed. This simple strategy can dramatically improve your daily efficiency and reduce stress levels.",
                category: .productivity,
                iconName: "clock.badge.checkmark.fill"
            ),
            LifestyleTip(
                title: "Practice Deep Breathing",
                description: "Take 5 deep breaths when feeling stressed. Inhale for 4 counts, hold for 4, exhale for 6. This activates your parasympathetic nervous system.",
                category: .mindfulness,
                iconName: "lungs.fill"
            ),
            LifestyleTip(
                title: "Take the Stairs",
                description: "Choose stairs over elevators when possible. This simple change can significantly increase your daily activity level and improve cardiovascular health.",
                category: .fitness,
                iconName: "figure.stairs"
            ),
            LifestyleTip(
                title: "Eat the Rainbow",
                description: "Include colorful fruits and vegetables in your meals. Different colors provide different nutrients and antioxidants for optimal health.",
                category: .health,
                iconName: "carrot.fill"
            ),
            LifestyleTip(
                title: "Batch Similar Tasks",
                description: "Group similar activities together to maintain focus and reduce context switching. For example, answer all emails at once rather than throughout the day.",
                category: .productivity,
                iconName: "rectangle.3.group.fill"
            ),
            LifestyleTip(
                title: "Practice Gratitude",
                description: "Write down three things you're grateful for each day. This simple practice can significantly improve your mood and overall life satisfaction.",
                category: .mindfulness,
                iconName: "heart.text.square.fill"
            ),
            LifestyleTip(
                title: "Walk After Meals",
                description: "Take a 10-15 minute walk after eating to aid digestion, stabilize blood sugar, and boost your energy levels naturally.",
                category: .fitness,
                iconName: "figure.walk"
            )
        ]
    }
    
    // MARK: - Daily Challenges
    func getDailyChallenge() -> DailyChallenge {
        let challenges = [
            DailyChallenge(
                title: "Hydration Hero",
                description: "Drink 8 glasses of water today",
                targetValue: 8,
                unit: "glasses",
                iconName: "drop.fill"
            ),
            DailyChallenge(
                title: "Step Master",
                description: "Take 10,000 steps today",
                targetValue: 10000,
                unit: "steps",
                iconName: "figure.walk"
            ),
            DailyChallenge(
                title: "Gratitude Practice",
                description: "Write down 3 things you're grateful for",
                targetValue: 3,
                unit: "items",
                iconName: "heart.text.square.fill"
            ),
            DailyChallenge(
                title: "Reading Time",
                description: "Read for 30 minutes",
                targetValue: 30,
                unit: "minutes",
                iconName: "book.fill"
            ),
            DailyChallenge(
                title: "Deep Breathing",
                description: "Complete 5 deep breathing exercises",
                targetValue: 5,
                unit: "exercises",
                iconName: "lungs.fill"
            )
        ]
        
        // Return a random challenge for today
        return challenges.randomElement() ?? challenges[0]
    }
    
    // MARK: - Achievements
    func getAchievements() -> [Achievement] {
        return [
            Achievement(
                title: "First Steps",
                description: "Complete your first daily challenge",
                iconName: "star.fill",
                category: .challenges,
                rarity: .common
            ),
            Achievement(
                title: "Knowledge Seeker",
                description: "Read 5 educational articles",
                iconName: "book.fill",
                category: .education,
                rarity: .common
            ),
            Achievement(
                title: "Game Master",
                description: "Score over 100 points in any mini-game",
                iconName: "gamecontroller.fill",
                category: .games,
                rarity: .rare
            ),
            Achievement(
                title: "Wellness Warrior",
                description: "Read 10 lifestyle tips",
                iconName: "heart.fill",
                category: .lifestyle,
                rarity: .common
            ),
            Achievement(
                title: "Streak Master",
                description: "Complete challenges for 7 days in a row",
                iconName: "flame.fill",
                category: .challenges,
                rarity: .epic
            ),
            Achievement(
                title: "Scholar",
                description: "Complete all educational content",
                iconName: "graduationcap.fill",
                category: .education,
                rarity: .epic
            ),
            Achievement(
                title: "High Scorer",
                description: "Achieve a perfect score in memory game",
                iconName: "trophy.fill",
                category: .games,
                rarity: .legendary
            ),
            Achievement(
                title: "Life Optimizer",
                description: "Complete 50 daily challenges",
                iconName: "target",
                category: .challenges,
                rarity: .legendary
            )
        ]
    }
}