//
//  PostTabContainer.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import SwiftUI

struct PostTabContainer: View {
    @State private var router = NavigationRouter<PostRoute>()
    
    var body: some View {
        NavigationStack(path: $router.path) {
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
                    }
                }
        }
        .environment(router)
    }
}

#Preview {
    PostTabContainer()
}
