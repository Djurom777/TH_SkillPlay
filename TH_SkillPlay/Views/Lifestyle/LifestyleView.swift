//
//  LifestyleView.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

import SwiftUI

struct LifestyleView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var lifestyleViewModel = LifestyleViewModel()
    @State private var showTips = false
    @State private var expandedTips: Set<UUID> = []
    
    var body: some View {
        ZStack {
            Color.lightGray
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Category Filter
                CategoryFilterView(
                    selectedCategory: lifestyleViewModel.selectedCategory,
                    onCategorySelected: { category in
                        lifestyleViewModel.filterTips(by: category)
                    }
                )
                .opacity(showTips ? 1.0 : 0.0)
                .offset(y: showTips ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showTips)
                
                // Tips List
                ScrollView {
                    LazyVStack(spacing: Spacing.cardSpacing) {
                        // Header
                        LifestyleHeaderView()
                            .opacity(showTips ? 1.0 : 0.0)
                            .offset(y: showTips ? 0 : -20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showTips)
                        
                        // Tips
                        ForEach(Array(lifestyleViewModel.filteredTips.enumerated()), id: \.element.id) { index, tip in
                                                    LifestyleTipCard(
                            tip: tip,
                            isRead: appViewModel.userProgress.readLifestyleTips.contains(tip.id),
                            isExpanded: expandedTips.contains(tip.id),
                            onToggleExpanded: {
                                if expandedTips.contains(tip.id) {
                                    expandedTips.remove(tip.id)
                                } else {
                                    expandedTips.insert(tip.id)
                                }
                            }
                        ) {
                            appViewModel.userProgress.readLifestyleTip(tip)
                            lifestyleViewModel.markTipAsRead(tip)
                        }
                            .opacity(showTips ? 1.0 : 0.0)
                            .offset(y: showTips ? 0 : 30)
                            .scaleEffect(showTips ? 1.0 : 0.95)
                            .animation(
                                AnimationHelpers.staggeredAnimation(index: index, delay: 0.08),
                                value: showTips
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.safeAreaPadding)
                    .padding(.vertical, Spacing.medium)
                }
            }
        }
        .navigationTitle("Lifestyle")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            lifestyleViewModel.refreshLifestyleTips()
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showTips = true
            }
        }
    }
}

struct LifestyleHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Live Better Every Day")
                        .font(Typography.sectionHeader)
                        .foregroundColor(Color.darkGray)
                    
                    Text("Discover practical tips to improve your daily life and well-being.")
                        .font(Typography.bodyText)
                        .foregroundColor(Color.darkGray.opacity(0.7))
                        .lineLimit(nil)
                }
                
                Spacer()
            }
        }
    }
}

struct CategoryFilterView: View {
    let selectedCategory: LifestyleTipCategory?
    let onCategorySelected: (LifestyleTipCategory?) -> Void
    
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
                ForEach(LifestyleTipCategory.allCases, id: \.self) { category in
                    FilterButton(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        color: category.color
                    ) {
                        onCategorySelected(category)
                    }
                }
            }
            .padding(.horizontal, Spacing.safeAreaPadding)
        }
        .padding(.vertical, Spacing.small)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, Spacing.medium)
                .padding(.vertical, Spacing.small)
                .background(isSelected ? color : color.opacity(0.1))
                .cornerRadius(20)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}



struct LifestyleTipCard: View {
    let tip: LifestyleTip
    let isRead: Bool
    let isExpanded: Bool
    let onToggleExpanded: () -> Void
    let onRead: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack(alignment: .top) {
                // Icon
                ZStack {
                    Circle()
                        .fill(tip.category.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: tip.iconName)
                        .font(.system(size: UIConstants.iconSizeMedium))
                        .foregroundColor(tip.category.color)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text(tip.title)
                            .font(Typography.cardTitle)
                            .foregroundColor(Color.darkGray)
                        
                        Spacer()
                        
                        if isRead {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: UIConstants.iconSizeSmall))
                                .foregroundColor(Color.grassGreen)
                        }
                    }
                    
                    Text(tip.category.rawValue)
                        .font(Typography.caption)
                        .foregroundColor(tip.category.color)
                        .padding(.horizontal, Spacing.small)
                        .padding(.vertical, 2)
                        .background(tip.category.color.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            Text(tip.description)
                .font(Typography.cardSubtitle)
                .foregroundColor(Color.darkGray.opacity(0.8))
                .lineLimit(isExpanded ? nil : 2)
            

            
            // Read More Button - Working Version
            HStack {
                Button(action: {
                    print("🔥 Read More button tapped!")
                    withAnimation(.easeInOut(duration: 0.3)) {
                        onToggleExpanded()
                    }
                    if isExpanded && !isRead {
                        onRead()
                    }
                }) {
                    HStack(spacing: 4) {
                        Text(isExpanded ? "Read Less" : "Read More")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(tip.category.color)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(tip.category.color.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                if isExpanded && !isRead {
                    Button(action: {
                        print("✅ Mark as Read button tapped!")
                        onRead()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .semibold))
                            
                            Text("Mark as Read")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(tip.category.color)
                        .cornerRadius(16)
                    }
                }
            }
        }
        .padding(Spacing.medium)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Lifestyle ViewModel Extension
extension LifestyleViewModel {
    func refreshLifestyleTips() {
        // This method is called from the view to ensure data is loaded
        // The actual loading happens in init(), but this provides a way to refresh if needed
        let dataService = DataService.shared
        lifestyleTips = dataService.getLifestyleTips()
        filteredTips = lifestyleTips
    }
}

#Preview {
    LifestyleView(appViewModel: AppViewModel())
}