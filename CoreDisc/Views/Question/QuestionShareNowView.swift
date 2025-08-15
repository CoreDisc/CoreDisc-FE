//
//  QuestionShareNowView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/16/25.
//

import SwiftUI

struct QuestionShareNowView: View {
    @StateObject private var viewModel = SharedQuestionViewModel()
    @StateObject private var selectViewModel = QuestionBasicViewModel()
    
    private let spacingAngle: Double = 19
    @State private var hiddenCount = 0
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var mainViewModel: QuestionMainViewModel
    let selectedQuestionType: String
    let order: Int
    
    @State var showSelectModal: Bool = false
    
    // 질문 선택/저장 용도
    @State private var selectedQuestionId: Int? = nil
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                InfoGroup
                Spacer()
                CircularScrollView
            }
            
            VStack {
                Spacer()
                NavigationLink(destination: QuestionListView(
                    mainViewModel: mainViewModel,
                    isSaveMode: true,
                    selectedQuestionType: selectedQuestionType,
                    order: order)
                ) {
                    PrimaryActionButton(title: "저장한 공유질문 보기", isFinished: .constant(true))
                        .padding(.horizontal, 21)
                }
                Spacer().frame(height: 60)
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            viewModel.fetchMySharedQuestions()
        }
    }
    
    private var InfoGroup: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(.iconBack)
                }
                .padding(.leading, 17)
                
                Spacer()
                
                NavigationLink(destination: QuestionListView(
                    mainViewModel: mainViewModel,
                    isSaveMode: false,
                    selectedQuestionType: selectedQuestionType,
                    order: order)
                ) {
                    Image(.iconList)
                }
                .padding(.trailing, 18)
            }
            
            Text("현재 발행한 공유 질문")
                .textStyle(.Title_Text_Ko)
                .foregroundStyle(.key)
                .padding(.leading, 17)
            
            HStack(spacing: 6) {
                Text("\(viewModel.mySharedQuestionCnt)")
                    .textStyle(.Title_Text_Ko)
                    .foregroundStyle(.white)
                Text("개")
                    .textStyle(.Title_Text_Ko)
                    .foregroundStyle(.white)
            }
            .padding(.leading, 17)
            
            Text("사용자들과 공유한 질문들을 확인해보세요!")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 17)
        }
    }
    
    private var CircularScrollView: some View {
        GeometryReader { geometry in
            let radius = geometry.size.height / 1.2
            let center = CGPoint(x: geometry.size.width - radius * 1.4,
                                 y: geometry.size.height / 7)
            
            ZStack {
                ForEach(viewModel.mySharedQuestions.indices, id: \.self) { index in
                    if index >= hiddenCount {
                        let visibleIndex = index - hiddenCount
                        let itemAngle = Angle(degrees: Double(visibleIndex) * spacingAngle)
                        let totalAngle = itemAngle
                        
                        let x = center.x + radius * CGFloat(cos(totalAngle.radians))
                        let y = center.y + radius * CGFloat(sin(totalAngle.radians))
                        
                        let question = viewModel.mySharedQuestions[index]
                        
                        QuestionShareItem(
                            type: "share",
                            category: question.categories.first?.categoryName ?? "",
                            content: question.question,
                            date: question.createdAt,
                            sharedCount: question.sharedCount,
                            index: index + 1,
                            onTap: {
                                showSelectModal = true
                                selectedQuestionId = question.id
                            },
                            selectViewModel: selectViewModel
                        )
                        .padding(.horizontal, 24)
                        .rotationEffect(totalAngle)
                        .position(x: x, y: y)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        
                        if value.translation.height < -threshold {
                            if hiddenCount < viewModel.mySharedQuestions.count - 1 {
                                withAnimation(.spring()) {
                                    hiddenCount += 1
                                }
                            }
                        } else if value.translation.height > threshold {
                            if hiddenCount > 0 {
                                withAnimation(.spring()) {
                                    hiddenCount -= 1
                                }
                            }
                        }
                    }
            )
            .frame(height: 636)
        }
    }
}
