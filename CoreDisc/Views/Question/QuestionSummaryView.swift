//
//  QuestionSummaryView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/13/25.
//
import SwiftUI

struct QuestionSummaryView: View {
    @Environment(NavigationRouter<QuestionRoute>.self) private var router
    
    let questionId: Int?
    let selectedCategory: CategoryType?
    @State var text: String
    
    @StateObject private var viewModel = QuestionSummaryViewModel()
    @StateObject private var sharedQuestionVM = SharedQuestionViewModel()
    
    @State var isShareSuccess: Bool = false
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: { router.pop() }) {
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
                        Spacer().frame(height: 65)
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
                            .foregroundStyle(selectedCategory?.color ?? LinearGradient(
                                colors: [.clear],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                        Text(selectedCategory?.title ?? "")
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
                        Text(text)
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
    
    var ButtonGroup: some View {
        VStack (spacing: 12) {
            // 저장하기
            PrimaryActionButton(title: "작성한 질문 저장하기", isFinished: .constant(true))
                .onTapGesture {
                    if let qId = questionId {
                        // 수정
                        viewModel.rewritePersonalQuestion(
                            questionId: qId,
                            categoryIds: [selectedCategory?.id ?? 0],
                            question: text
                        ) { success in
                            if success {
                                ToastManager.shared.show("질문이 수정되었습니다.")
                                router.reset()
                            }
                        }
                    } else {
                        // 신규 저장
                        guard let categoryId = selectedCategory?.id else {
                            ToastManager.shared.show("카테고리를 선택해주세요.")
                            return
                        }
                        viewModel.savePersonalQuestion(
                            categoryIds: [categoryId],
                            question: text
                        ) { success in
                            if success {
                                router.reset()
                            }
                        }
                    }
                }
            
            // 공유하기
            PrimaryActionButton(title: "작성한 질문 공유하기", isFinished: .constant(true))
                .onTapGesture {
                    viewModel.shareOfficialQuestion(
                        categoryIds: [selectedCategory?.id ?? 0],
                        question: text
                    ) { success in
                        if success {
                            router.reset()
                            router.push(.shareNow(
                                selectedQuestionType: "official",
                                order: 0
                            ))
                        } else {
                            ToastManager.shared.show("질문 공유에 실패했습니다. 다시 시도해주세요.")
                        }
                    }
                }

            
            
            Button {
                router.pop() // 기존 WriteView로 돌아가기
            } label: {
                PrimaryActionButton(title: "질문 재작성하기", isFinished: .constant(true))
            }
        }
        .padding(.horizontal, 21)
    }
}

