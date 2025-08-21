//
//  TabView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/4/25.
//

import SwiftUI

enum Tab {
    case post, write, question, report, myhome
}

enum TabBarStyle {
    case dark, light
}

struct TabBar: View {
    @State private var selectedTab: Tab = .question
    @State private var tabBarStyle: TabBarStyle = .light
    @StateObject private var tabBarVisibility = TabBarVisibility()
    
    @State private var postRouter = NavigationRouter<PostRoute>()
    @State private var writeRouter = NavigationRouter<WriteRoute>()
    @State private var questionRouter = NavigationRouter<QuestionRoute>()
    @State private var reportRouter = NavigationRouter<ReportRoute>()
    @State private var myhomeRouter = NavigationRouter<MyhomeRoute>()
    
    @StateObject private var mainViewModel = QuestionMainViewModel()
    @StateObject private var homeViewModel = MyHomeViewModel()
    
    init(startTab: Tab = .question) {
        _selectedTab = State(initialValue: startTab)
        _tabBarStyle = State(initialValue: {
            switch startTab {
            case .post: return .dark
            case .write: return .light
            case .question: return .light
            case .report: return .light
            case .myhome: return .light
            }
        }())
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .post:
                    NavigationStack(path: $postRouter.path) {
                        PostTabContainer()
                    }
                    .environment(writeRouter)
                    .environment(postRouter)
                    .environment(myhomeRouter)
                    .environmentObject(homeViewModel)
                    
                case .write:
                    NavigationStack(path: $writeRouter.path) {
                        WriteTabContainer()
                    }
                    .environment(writeRouter)
                    
                case .question:
                    NavigationStack(path: $questionRouter.path) {
                        QuestionTabContainer()
                    }
                    .environment(questionRouter)
                    .environmentObject(mainViewModel)
                    
                case .report:
                    NavigationStack(path: $reportRouter.path) {
                        ReportTabContainer()
                    }
                    .environment(reportRouter)
                    
                case .myhome:
                    NavigationStack(path: $myhomeRouter.path) {
                        MyhomeTabContainer()
                    }
                    .environment(myhomeRouter)
                    .environment(postRouter)
                    .environmentObject(homeViewModel)
                }
            }
            .environmentObject(tabBarVisibility)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 탭바 숨김
            if !tabBarVisibility.isHidden {
                CustomTabBar(
                    selectedTab: $selectedTab,
                    tabBarStyle: tabBarStyle,
                    onReselect: { tab in
                        // 같은 탭을 다시 탭했을 때 라우터 리셋
                        switch tab {
                        case .post: postRouter.reset()
                        case .write: writeRouter.reset()
                        case .question: questionRouter.reset()
                        case .report: reportRouter.reset()
                        case .myhome: myhomeRouter.reset()
                        }
                    }
                )
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
        case .post: .dark
        case .write: .light
        case .question: .light
        case .report: .light
        case .myhome: .light
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var tabBarStyle: TabBarStyle
    let onReselect: (Tab) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(tabBarStyle == .dark ? .black000 : .white)
                    .frame(height: 54)
                    .padding(.horizontal, 24)
                
                HStack(spacing: 19) {
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .post, icon: "icon_home", onReselect: onReselect)
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .write, icon: "icon_pencil", onReselect: onReselect)
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .question, icon: "icon_disk", onReselect: onReselect)
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .report, icon: "icon_museum", onReselect: onReselect)
                    TabBarItem(selectedTab: $selectedTab, tabBarStyle: tabBarStyle, tab: .myhome, icon: "icon_mypage", onReselect: onReselect)
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
    let onReselect: (Tab) -> Void
    
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
            if selectedTab == tab {
                onReselect(tab)
            } else {
                selectedTab = tab
            }
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
