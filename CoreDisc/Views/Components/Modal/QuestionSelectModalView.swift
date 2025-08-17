//
//  QuestionSelectModalView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/15/25.
//

import SwiftUI

struct QuestionSelectModalView: View {
    @Environment(NavigationRouter<QuestionRoute>.self) private var router
    @EnvironmentObject var mainViewModel: QuestionMainViewModel
    
    let isMonth: String
    @Binding var selectedQuestionId: Int?
    let order: Int
    let selectedQuestionType: SelectedQuestionType
    
    @ObservedObject var viewModel: QuestionBasicViewModel
    
    @Binding var showSelectModal: Bool
    
    @Binding var goToMain: Bool
    
    var body: some View {
        ModalView {
            VStack(spacing: 6) {
                Text("\(isMonth == "FIXED" ? "한달" : "하루")질문으로 선택할까요?")
                    .textStyle(.Button)
                
                Text("한번 설정한 \(isMonth == "FIXED" ? "한달" : "하루")질문은 \(isMonth == "FIXED" ? "30일간" : "하루동안") 변경이 불가능합니다.")
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.red)
            }
        } leftButton: {
            Button(action: {
                guard let questionId = selectedQuestionId else { return }
                
                if isMonth == "FIXED" {
                    let data = FixedData(
                        selectedQuestionType: selectedQuestionType,
                        questionOrder: order,
                        questionId: questionId
                    )
                    viewModel.fetchFixedBasic(fixedData: data)
                    mainViewModel.fetchSelected()
                } else {
                    let data = RandomData(
                        selectedQuestionType: selectedQuestionType,
                        questionId: questionId
                    )
                    viewModel.fetchRandomBasic(randomData: data)
                    mainViewModel.fetchSelected()
                }
                
                showSelectModal.toggle() // 모달 제거
                goToMain = true
            }) {
                Text("설정하기")
            }
        } rightButton: {
            Button(action: {
                showSelectModal.toggle() // 모달 제거
            }) {
                Text("뒤로가기")
            }
        }
    }
}
