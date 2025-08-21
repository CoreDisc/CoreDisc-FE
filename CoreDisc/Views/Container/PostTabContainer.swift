//
//  PostTabContainer.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import SwiftUI

struct PostTabContainer: View {
    @StateObject private var myHomeVM = MyHomeViewModel()
    
    var body: some View {
        PostMainView()
            .task {
                    if myHomeVM.username.isEmpty {
                        myHomeVM.fetchMyHome()
                    }
                }
            .navigationDestination(for: PostRoute.self) { route in
                switch route {
                case .home:
                    PostMainView()
                case .search:
                    SearchView(myHomeVM: myHomeVM)
                case .notification:
                    NotificationView()
                case .detail(let postId):
                    PostDetailView(hosting: .post, postId: postId)
                case .searchResult(let query):
                    SearchResultView(initialQuery: query,
                                     isSearch: .constant(false),
                                     myUsername: myHomeVM.username)
                    
                case .user(let userName):
                    UserHomeView(hosting: .post, userName: userName)
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
