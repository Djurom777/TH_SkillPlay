//
//  EducationView.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import SwiftUI

struct EducationView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var educationViewModel = EducationViewModel()
    @State private var showCards = false
    
    var body: some View {
        ZStack {
            Color.lightGray
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: Spacing.cardSpacing) {
                    // Header
                    HeaderView()
                        .opacity(showCards ? 1.0 : 0.0)
                        .offset(y: showCards ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showCards)
                    
                    // Learning Cards
                    ForEach(Array(educationViewModel.learningCards.enumerated()), id: \.element.id) { index, card in
                        LearningCardView(
                            card: card,
                            isCompleted: appViewModel.userProgress.completedLearningCards.contains(card.id)
                        ) {
                            educationViewModel.selectCard(card)
                        }
                        .opacity(showCards ? 1.0 : 0.0)
                        .offset(y: showCards ? 0 : 30)
                        .scaleEffect(showCards ? 1.0 : 0.95)
                        .animation(
                            AnimationHelpers.staggeredAnimation(index: index, delay: 0.1),
                            value: showCards
                        )
                    }
                }
                .padding(.horizontal, Spacing.safeAreaPadding)
                .padding(.vertical, Spacing.medium)
            }
        }
        .navigationTitle("Education")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showCards = true
            }
        }
        .sheet(isPresented: $educationViewModel.showingDetail) {
            if let selectedCard = educationViewModel.selectedCard {
                LearningCardDetailView(
                    card: selectedCard,
                    isCompleted: appViewModel.userProgress.completedLearningCards.contains(selectedCard.id),
                    onComplete: {
                        print("onComplete callback triggered for card: \(selectedCard.title)")
                        appViewModel.userProgress.completeEducationCard(selectedCard)
                        educationViewModel.markCardAsCompleted(selectedCard)
                    }
                )
            }
        }
    }
}

struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Expand Your Knowledge")
                        .font(Typography.sectionHeader)
                        .foregroundColor(Color.darkGray)
                    
                    Text("Discover articles designed to help you grow and learn new skills.")
                        .font(Typography.bodyText)
                        .foregroundColor(Color.darkGray.opacity(0.7))
                        .lineLimit(nil)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, Spacing.safeAreaPadding)
    }
}

struct LearningCardView: View {
    let card: LearningCard
    let isCompleted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.medium) {
                HStack {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(Color.skyBlue.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: card.iconName)
                            .font(.system(size: UIConstants.iconSizeMedium))
                            .foregroundColor(Color.skyBlue)
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(card.title)
                            .font(Typography.cardTitle)
                            .foregroundColor(Color.darkGray)
                            .multilineTextAlignment(.leading)
                        
                        Text(card.category)
                            .font(Typography.caption)
                            .foregroundColor(Color.skyBlue)
                            .padding(.horizontal, Spacing.small)
                            .padding(.vertical, 2)
                            .background(Color.skyBlue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: UIConstants.iconSizeMedium))
                            .foregroundColor(Color.grassGreen)
                    }
                }
                
                Text(card.description)
                    .font(Typography.cardSubtitle)
                    .foregroundColor(Color.darkGray.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                HStack {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color.darkGray.opacity(0.6))
                        
                        Text("\(card.estimatedReadTime) min read")
                            .font(Typography.caption)
                            .foregroundColor(Color.darkGray.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Text("Read More")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.skyBlue)
                }
            }
            .padding(Spacing.medium)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LearningCardDetailView: View {
    let card: LearningCard
    let isCompleted: Bool
    let onComplete: () -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var showContent = false
    @State private var hasMarkedComplete: Bool
    
    init(card: LearningCard, isCompleted: Bool, onComplete: @escaping () -> Void) {
        self.card = card
        self.isCompleted = isCompleted
        self.onComplete = onComplete
        self._hasMarkedComplete = State(initialValue: isCompleted)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightGray
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.large) {
                        // Header
                        VStack(alignment: .leading, spacing: Spacing.medium) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.skyBlue.opacity(0.2))
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: card.iconName)
                                        .font(.system(size: UIConstants.iconSizeLarge))
                                        .foregroundColor(Color.skyBlue)
                                }
                                .scaleEffect(showContent ? 1.0 : 0.8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: showContent)
                                
                                Spacer()
                            }
                            
                            Text(card.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color.darkGray)
                                .opacity(showContent ? 1.0 : 0.0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showContent)
                            
                            HStack {
                                Text(card.category)
                                    .font(Typography.caption)
                                    .foregroundColor(Color.skyBlue)
                                    .padding(.horizontal, Spacing.small)
                                    .padding(.vertical, 4)
                                    .background(Color.skyBlue.opacity(0.1))
                                    .cornerRadius(8)
                                
                                Spacer()
                                
                                HStack(spacing: Spacing.xs) {
                                    Image(systemName: "clock.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.darkGray.opacity(0.6))
                                    
                                    Text("\(card.estimatedReadTime) min read")
                                        .font(Typography.caption)
                                        .foregroundColor(Color.darkGray.opacity(0.6))
                                }
                            }
                            .opacity(showContent ? 1.0 : 0.0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)
                        }
                        .padding(.horizontal, Spacing.safeAreaPadding)
                        
                        // Content
                        VStack(alignment: .leading, spacing: Spacing.medium) {
                            Text(card.content)
                                .font(Typography.bodyText)
                                .foregroundColor(Color.darkGray)
                                .lineSpacing(4)
                        }
                        .padding(Spacing.medium)
                        .cardStyle()
                        .padding(.horizontal, Spacing.safeAreaPadding)
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showContent)
                        
                        // Complete Button
                        if !hasMarkedComplete {
                            Button(action: {
                                print("Mark as Complete button tapped!")
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    hasMarkedComplete = true
                                    onComplete()
                                }
                            }) {
                                Text("Mark as Complete")
                                    .frame(height: UIConstants.buttonHeight)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.primaryYellow)
                                    .foregroundColor(.white)
                                    .font(Typography.buttonText)
                                    .cornerRadius(UIConstants.buttonCornerRadius)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, Spacing.safeAreaPadding)
                            .opacity(showContent ? 1.0 : 0.0)
                            .offset(y: showContent ? 0 : 40)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: showContent)
                        } else {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: UIConstants.iconSizeMedium))
                                    .foregroundColor(Color.grassGreen)
                                
                                Text("Completed!")
                                    .font(Typography.buttonText)
                                    .foregroundColor(Color.grassGreen)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: UIConstants.buttonHeight)
                            .background(Color.grassGreen.opacity(0.1))
                            .cornerRadius(UIConstants.buttonCornerRadius)
                            .padding(.horizontal, Spacing.safeAreaPadding)
                            .scaleEffect(hasMarkedComplete ? 1.05 : 1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: hasMarkedComplete)
                        }
                    }
                    .padding(.vertical, Spacing.medium)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.skyBlue)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
        }
    }
}

#Preview {
    EducationView(appViewModel: AppViewModel())
}