//
//  PostTabContainer.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import SwiftUI

struct PostTabContainer: View {
    var body: some View {
        PostMainView()
            .navigationDestination(for: PostRoute.self) { route in
                switch route {
                case .home:
                    PostMainView()
                case .search:
                    SearchView()
                case .notification:
                    NotificationView()
                case .detail(let postId):
                    PostDetailView(postId: postId)
                    
                case .user(let userName):
                    UserHomeView(userName: userName)
                case .myHome:
                    MyHomeView()
                    
                case .write:
                    PostWriteView()
                case .questionMain:
                    QuestionMainView()
                }
            }
    }
}

#Preview {
    PostTabContainer()
}
