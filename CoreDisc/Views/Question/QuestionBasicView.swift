//
//  QuestionBasicView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct QuestionBasicView: View {
    @StateObject private var viewModel = QuesitonBasicViewModel()
    
    @Environment(\.dismiss) var dismiss
    @State var showModal: Bool = false
    private let topAnchorID = "top" // 스크롤 초기화 용도
    
    // 질문 선택 용도
    let order: Int
    @State private var selectedQuestionId: Int? = nil
    
    // 열려있는 카테고리
    @State private var expandedCategoryIDs: Set<UUID> = []
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                TopGroup
                
                Spacer().frame(height: 21)
                
                searchGroup
                
                Spacer().frame(height: 17)
                
                categoryGroup
            }
            
            // 선택 확인 모달
            if showModal {
                ModalView {
                    VStack(spacing: 10) {
                        Text("고정질문으로 선택할까요?")
                            .textStyle(.Q_Main)
                        
                        Text("한번 설정한 고정질문은 30일간 변경이 불가능합니다.")
                            .textStyle(.Button_s)
                            .foregroundStyle(.red)
                    }
                } leftButton: {
                    Button(action: {
                        if let questionId = selectedQuestionId {
                           let data = FixedData(
                               selectedQuestionType: .DEFAULT,
                               questionOrder: order,
                               questionId: questionId
                           )
                            viewModel.fetchFixedBasic(fixedData: data)
                        }
                        showModal.toggle() // 모달 제거
                        dismiss()
                    }) {
                        Text("설정하기")
                    }
                } rightButton: {
                    Button(action: {
                        showModal.toggle() // 모달 제거
                    }) {
                        Text("뒤로가기")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.fetchCategories()
        }
    }
    
    // MARK: - group
    
    // 상단 타이틀
    private var TopGroup: some View {
        VStack(alignment: .leading, spacing: 9) {
            Button(action: {
                dismiss()
            }) {
                Image(.iconBack)
            }
            
            Text("Select your own disc")
                .textStyle(.Title_Text_Eng)
                .foregroundStyle(.key)
                .padding(.leading, 9)
            
            Text("한 달동안 함께할 질문을 설정하세요.")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 9)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 17)
    }
    
    // 검색창
    private var searchGroup: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 22.5)
                .foregroundStyle(.black000)
                .frame(height: 45)
                .shadow(
                    color: .white.opacity(0.5),
                    radius: 2.4, x: 0, y: 0)
            
            Image(.iconSearchWhite)
                .padding(.leading, 13)
        }
        .padding(.horizontal, 25)
    }
    
    // 카테고리 목록
    private var categoryGroup: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                List {
                    Section {
                        ForEach(viewModel.categoryItem) { item in
                            QuestionBasicCategoryItem(
                                title: item.title,
                                count: item.count,
                                startColor: item.startColor,
                                endColor: item.endColor
                            )
                            .onTapGesture {
                                withAnimation {
                                    toggleExpanded(for: item.id)
                                    viewModel.fetchBasicLists(categoryUUID: item.id, categoryId: item.categoryId)
                                }
                            }
                            
                            if expandedCategoryIDs.contains(item.id),
                               let questionList = viewModel.questionListMap[item.id] {
                                ForEach(Array(questionList.enumerated()), id: \.element.id) { index, question in
                                    QuestionBasicDetailItem(
                                        showModal: $showModal,
                                        title: question.question,
                                        startColor: item.startColor,
                                        endColor: item.endColor,
                                        questionId: question.id,
                                        onSelect: { id in
                                            selectedQuestionId = id
                                        }
                                    )
                                    .onAppear {
                                        if index == questionList.count - 1 {
                                            // 마지막 셀에 도달했을 때
                                            let last = question
                                            viewModel.fetchBasicLists(
                                                categoryUUID: item.id,
                                                categoryId: item.categoryId,
                                                cursorCreatedAt: last.createdAt,
                                                cursorQuestionType: last.questionType,
                                                cursorId: last.id
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .listRowSeparator(.hidden) // 구분선 제거
                        .listRowBackground(Color.clear) // 리스트 기본 색상 제거
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 21))
                    } header: {
                        
                        // 스크롤 초기화용 뷰 (최상단 기준)
                        EmptyView()
                            .frame(height: 0)
                            .id(topAnchorID)
                    }
                }
                .listStyle(.plain) // list 주변영역 제거
                .listRowSpacing(24) // 리스트 간격
                .scrollContentBackground(.visible) // 기본 배경 색상 제거
                .padding(.leading, 21)
                
                // 스크롤 초기화 버튼
                Button(action: {
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(topAnchorID, anchor: .top)
                    }
                }) {
                    Image(.iconUp)
                }
            }
        }
    }
    
    // MARK: - function
    
    // 카테고리 열기/닫기 토글
    private func toggleExpanded(for id: UUID) {
        if expandedCategoryIDs.contains(id) {
            expandedCategoryIDs.remove(id)
        } else {
            expandedCategoryIDs.insert(id)
        }
    }
}

// MARK: - component

// 질문 카테고리
struct QuestionBasicCategoryItem: View {
    var title: String
    var count: Int
    var startColor: Color
    var endColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.shadow(.inner(
                    color: .shadow,
                    radius: 6,
                    y: -4)))
                .linearGradient(
                    startColor: startColor,
                    endColor: endColor)
                .frame(height: 64)
            
            HStack {
                Text(title)
                    .textStyle(.Q_Main)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("+\(count)")
                    .textStyle(.Q_Main)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 23)
        }
        .swipeActions(edge: .leading) {
            Button(action: { // TODO: action
                print("More menu tapped")
            }) {
                Image(.imgMoreButton)
            }
            .tint(.clear) // 기본 배경 제거
        }
        .navigationBarBackButtonHidden()
    }
}

// 질문 상세
struct QuestionBasicDetailItem: View {
    @Binding var showModal: Bool
    
    var title: String
    var startColor: Color
    var endColor: Color
    
    var questionId: Int
    var onSelect: (Int) -> Void
    
    var body: some View {
        Button(action: {
            showModal.toggle()
            onSelect(questionId)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.black000)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [startColor, endColor],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 3
                            )
                    )
                    .frame(minHeight: 64)
                
                Text(title.splitCharacter())
                    .textStyle(.Q_Main)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 23)
                    .padding(.vertical, 14)
            }
        }
    }
}

#Preview {
    QuestionBasicView(order: 1)
}
