//
//  SimpleTestView.swift
//  RaceTrian
//
//  Simple test view to verify tab bar functionality
//

import SwiftUI

struct SimpleTestView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Content Area
            ZStack {
                if selectedTab == 0 {
                    Color.red
                } else if selectedTab == 1 {
                    Color.green
                } else if selectedTab == 2 {
                    Color.blue
                } else if selectedTab == 3 {
                    Color.purple
                } else {
                    Color.orange
                }
                
                VStack(spacing: 20) {
                    Text("TAB \(selectedTab)")
                        .font(.system(size: 60, weight: .black))
                        .foregroundColor(.white)
                    
                    Text("Tap buttons below")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            
            // Bottom Toolbar - ALWAYS VISIBLE
            HStack(spacing: 0) {
                ToolbarButton(icon: "house.fill", title: "Home", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                ToolbarButton(icon: "calendar.circle.fill", title: "Today", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                
                ToolbarButton(icon: "calendar.badge.clock", title: "Plan", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
                
                ToolbarButton(icon: "chart.line.uptrend.xyaxis", title: "Progress", isSelected: selectedTab == 3) {
                    selectedTab = 3
                }
                
                ToolbarButton(icon: "ellipsis.circle.fill", title: "More", isSelected: selectedTab == 4) {
                    selectedTab = 4
                }
            }
            .frame(height: 80)
            .background(Color.white)
            .shadow(color: .black.opacity(0.1), radius: 5, y: -2)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ToolbarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .semibold))
                Text(title)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(isSelected ? .blue : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    SimpleTestView()
}
