//
//  QuestionSummaryView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/13/25.
//

import SwiftUI

struct QuestionSummaryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = QuestionSummaryViewModel()
    
    let category: CategoryType
    let question: String
    
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }){
                        Image(.iconBack)
                    }
                    .padding(.leading, 17)
                    Spacer()
                }
                ScrollView {
                    VStack {
                        QuestionSummaryGroup
                        Spacer().frame(height: 14)
                        ButtonGroup
                        Spacer().frame(height: 60)
                    }
                }
                .scrollIndicators(.hidden)
            }
            
            
        }
        .navigationBarBackButtonHidden()
    }
    
    var QuestionSummaryGroup: some View {
        VStack {
            
            Spacer().frame(height: 23)
            
            ZStack {
                VStack(spacing: 0) {
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 0,
                        bottomLeading: 12,
                        bottomTrailing: 12,
                        topTrailing: 0))
                    .padding(.horizontal, 21)
                    .foregroundStyle(.gray400)
                    
                    Triangle()
                        .foregroundStyle(.gray400)
                        .frame(width: 93, height: 20)
                }
                
                VStack(alignment: .leading) {
                    Text("작성 질문 요약")
                        .textStyle(.Title3_Text_Ko)
                        .padding(.top, 28)
                        .padding(.leading, 51)
                    
                    Spacer().frame(height: 32)
                    
                    Text("선택한 카테고리")
                        .textStyle(.Q_Main)
                        .padding(.leading, 48)
                    
                    Spacer().frame(height: 8)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .padding(.horizontal, 21)
                            .frame(height: 60)
                            .foregroundStyle(category.color)
                        Text(category.title)
                            .textStyle(.Q_Main)
                            .foregroundStyle(.black000)
                            .padding(.leading, 48)
                    }
                    
                    Spacer().frame(height: 32)
                    
                    Text("작성한 질문 내용")
                        .textStyle(.Q_Main)
                        .padding(.leading, 48)
                    Spacer().frame(height: 10)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 21)
                            .frame(height: 180)
                        Text(question)
                            .textStyle(.Texting_Q)
                            .padding(.leading, 40)
                            .padding([.top, .bottom, .trailing], 20)
                    }
                    .padding(.horizontal, 21)
                    .padding(.bottom, 42)
                    
                }
                
                
            }
        }
    }
    
    var ButtonGroup: some View{
        VStack (spacing: 12) {
            NavigationLink(
                destination: QuestionShareNowView()
            ) {
                PrimaryActionButton(title: "작성한 질문 저장하기", isFinished: .constant(true))
            }
            .simultaneousGesture(TapGesture().onEnded {
                // 이동 전에 저장 로직 실행
                viewModel.savePersonalQuestion(
                    categoryIds: [category.id],
                    question: question
                )
            })
            NavigationLink(destination: QuestionShareNowView()) {
                PrimaryActionButton(title: "작성한 질문 공유하기", isFinished: .constant(true))
            }
            .simultaneousGesture(
                TapGesture().onEnded {
                    viewModel.shareOfficialQuestion(
                        categoryIds: [category.id],
                        question: question
                    ) { success in
                        if !success {
                            ToastManager.shared.show("질문 공유에 실패했습니다. 다시 시도해주세요.")
                        }
                    }
                })
            
            Button(action: {
                
            }) {
                PrimaryActionButton(title: "질문 재작성하기", isFinished: .constant(false))
            }
            
        }
        .padding(.horizontal, 21)
        
    }
}
