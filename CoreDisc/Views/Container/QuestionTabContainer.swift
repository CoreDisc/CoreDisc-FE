//
//  QuestionTabContainer.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import SwiftUI

struct QuestionTabContainer: View {
    @State private var router = NavigationRouter<QuestionRoute>()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            QuestionMainView()
                .navigationDestination(for: QuestionRoute.self) { route in
                    switch route {
                    case .main:
                        QuestionMainView()
                        
                    case .write:
                        QuestionWriteView()
                    case .summary(let questionId, let selectedCategory, let text):
                        QuestionSummaryView(
                            questionId: questionId,
                            selectedCategory: selectedCategory,
                            text: text
                        )
                        
                    case .basic:
//                        QuestionBasicView()
                        EmptyView()
                    
                    case .trending:
//                        QuestionTrendingView()
                        EmptyView()

                    case .shareNow:
//                        QuestionShareNowView()
                        EmptyView()
                    case .shareList:
//                        QuestionListView()
                        EmptyView()
                    }
                }
        }
        .environment(router)
    }
}

#Preview {
    QuestionTabContainer()
}
