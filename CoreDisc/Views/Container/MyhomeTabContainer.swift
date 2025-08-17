//
//  MyhomeTabContainer.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import SwiftUI

struct MyhomeTabContainer: View {
    @State private var router = NavigationRouter<MyhomeRoute>()
    @State private var postRouter = NavigationRouter<PostRoute>()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            MyHomeView()
                .navigationDestination(for: MyhomeRoute.self) { route in
                    switch route {
                    case .home:
                        MyHomeView()
                    case .core:
                        CoreQuestionsView()
                    case .edit:
                        EditProfileView()
                    case .post(let postId):
                        PostDetailView(postId: postId)
                        
                    case .calendar:
                        CalendarView()
                        
                    case .setting:
                        SettingView()
                    case .account:
                        AccountManageView()
                    case .block:
                        BlockListView()
                    case .notification:
                        NotificationSettingView()
                        
                    case .user(let userName):
                        UserHomeView(userName: userName)
                    }
                }
        }
        .environment(router)
        .environment(postRouter)
    }
}

#Preview {
    MyhomeTabContainer()
}
