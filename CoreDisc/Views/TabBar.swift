//
//  TabView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/4/25.
//

import SwiftUI

enum Tab {
    case home, disk, write, report, mypage
}

enum TabBarStyle {
    case dark, light
}

struct TabBar: View {
    @State private var selectedTab: Tab = .home
    @State private var tabBarStyle: TabBarStyle = .dark
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    MainView()
                case .disk:
                    QuestionMainView()
                case .write:
                    PostWriteView()
                case .report:
                    ReportMainView()
                case .mypage:
                    MypageView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            
            CustomTabBar(selectedTab: $selectedTab, tabBarStyle: tabBarStyle)
        }
        .onChange(of: selectedTab) {
            tabBarStyle = tabBarStyle(for: selectedTab)
        }
    }
    
    private func tabBarStyle(for tab: Tab) -> TabBarStyle {
        switch tab {
        case .home: .dark
        case .disk: .light
        case .write: .dark
        case .report: .light
        case .mypage: .light
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var tabBarStyle: TabBarStyle
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(tabBarStyle == .dark ? .tabDark : .tabLight)
                    .stroke(tabBarStyle == .dark ? .clear : .grayWbar, lineWidth: 0.5)
                    .frame(height: 54)
                    .padding(.horizontal, 24)
                
                HStack(spacing: 19) {
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .home, icon: "icon_home")
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .disk, icon: "icon_disk")
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .write, icon: "icon_pencil")
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .report, icon: "icon_museum")
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .mypage, icon: "icon_mypage")
                }
            }
        }
    }
}

struct TabBarItem: View {
    @Binding var selectedTab: Tab
    let tabBarStyle: TabBarStyle
    let tab: Tab
    let icon: String
    
    var selectedColor: Color {
        switch tabBarStyle {
        case .dark: .grayWbar
        case .light: .grayBbar
        }
    }
    
    var defaultColor: Color {
        switch tabBarStyle {
        case .dark: .grayBbar
        case .light: .grayWbar
        }
    }
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            Image(icon)
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundStyle(selectedTab == tab ? selectedColor : defaultColor)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TabBar()
}
