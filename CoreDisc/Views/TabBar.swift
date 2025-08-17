//
//  TabView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/4/25.
//

import SwiftUI

enum Tab {
    case home, write, disk, report, mypage
}

enum TabBarStyle {
    case dark, light
}

struct TabBar: View {
    @State private var selectedTab: Tab = .disk
    @State private var tabBarStyle: TabBarStyle = .light
    @StateObject private var tabBarVisibility = TabBarVisibility()
    
    init(startTab: Tab = .disk) {
        _selectedTab = State(initialValue: startTab)
        _tabBarStyle = State(initialValue: {
            switch startTab {
            case .home: return .dark
            case .write: return .dark
            case .disk: return .light
            case .report: return .light
            case .mypage: return .light
            }
        }())
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    PostTabContainer()
                case .write:
                    WriteTabContainer()
                case .disk:
                    QuestionMainView()
                case .report:
                    ReportMainView()
                case .mypage:
                    MyHomeView()
                }
            }
            .environmentObject(tabBarVisibility)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 탭바 숨김
            if !tabBarVisibility.isHidden {
                CustomTabBar(selectedTab: $selectedTab, tabBarStyle: tabBarStyle)
            }
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: selectedTab) {
            tabBarStyle = tabBarStyle(for: selectedTab)
            tabBarVisibility.reset()
        }
        .navigationBarBackButtonHidden()
        .overlay(alignment: .bottom) {
            GlobalToastView()
        }
    }
    
    private func tabBarStyle(for tab: Tab) -> TabBarStyle {
        switch tab {
        case .home: .dark
        case .write: .dark
        case .disk: .light
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
                    .fill(tabBarStyle == .dark ? .black000 : .white)
                    .frame(height: 54)
                    .padding(.horizontal, 24)
                
                HStack(spacing: 19) {
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .home, icon: "icon_home")
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .write, icon: "icon_pencil")
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .disk, icon: "icon_disk")
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
        case .dark: .gray200
        case .light: .gray800
        }
    }
    
    var defaultColor: Color {
        switch tabBarStyle {
        case .dark: .gray600
        case .light: .gray200
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
