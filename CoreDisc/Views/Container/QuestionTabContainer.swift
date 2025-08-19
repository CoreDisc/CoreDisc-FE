//
//  QuestionTabContainer.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import SwiftUI

struct QuestionTabContainer: View {
    
    var body: some View {
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
                    
                case .basic(let selectedQuestionType, let order):
                    QuestionBasicView(
                        selectedQuestionType: selectedQuestionType,
                        order: order
                    )
                    
                case .trending(let selectedQuestionType, let order):
                    QuestionTrendingView(
                        selectedQuestionType: selectedQuestionType,
                        order: order
                    )
                    
                case .shareNow(let selectedQuestionType, let order):
                    QuestionShareNowView(
                        selectedQuestionType: selectedQuestionType,
                        order: order
                    )
                case .shareList(let isSaveMode, let selectedQuestionType, let order):
                    QuestionListView(
                        isSaveMode: isSaveMode,
                        selectedQuestionType: selectedQuestionType,
                        order: order
                    )
                }
            }
    }
}

#Preview {
    QuestionTabContainer()
}
