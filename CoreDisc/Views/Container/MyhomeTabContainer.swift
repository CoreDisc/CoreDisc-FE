//
//  MyhomeTabContainer.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import SwiftUI

struct MyhomeTabContainer: View {
    var body: some View {
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
                    PostDetailView(hosting: .myhome, postId: postId)
                    
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
                    UserHomeView(hosting: .myhome, userName: userName)
                }
            }
    }
}

#Preview {
    MyhomeTabContainer()
}
