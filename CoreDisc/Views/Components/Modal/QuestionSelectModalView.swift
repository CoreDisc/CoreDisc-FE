//
//  QuestionSelectModalView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/15/25.
//

import SwiftUI

struct QuestionSelectModalView: View {
    @Environment(\.dismiss) var dismiss
    
    let selectedQuestionType: String
    @Binding var selectedQuestionId: Int?
    let order: Int
    
    @ObservedObject var viewModel: QuestionBasicViewModel
    @ObservedObject var mainViewModel: QuestionMainViewModel
    
    @Binding var showSelectModal: Bool
    
    var body: some View {
        ModalView {
            VStack(spacing: 6) {
                Text("\(selectedQuestionType == "FIXED" ? "한달" : "하루")질문으로 선택할까요?")
                    .textStyle(.Button)
                
                Text("한번 설정한 \(selectedQuestionType == "FIXED" ? "한달" : "하루")질문은 \(selectedQuestionType == "FIXED" ? "30일간" : "하루동안") 변경이 불가능합니다.")
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.red)
            }
        } leftButton: {
            Button(action: {
                guard let questionId = selectedQuestionId else { return }
                
                if selectedQuestionType == "FIXED" {
                    let data = FixedData(
                        selectedQuestionType: .DEFAULT,
                        questionOrder: order,
                        questionId: questionId
                    )
                    viewModel.fetchFixedBasic(fixedData: data)
                    mainViewModel.fetchSelected()
                } else {
                    let data = RandomData(
                        selectedQuestionType: .DEFAULT,
                        questionId: questionId
                    )
                    viewModel.fetchRandomBasic(randomData: data)
                    mainViewModel.fetchSelected()
                }
                
                showSelectModal.toggle() // 모달 제거
                dismiss()
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
