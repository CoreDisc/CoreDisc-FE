//
//  QuestionListView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/20/25.
//

import SwiftUI

struct QuestionListView: View {
    @StateObject private var viewModel = QuestionListViewModel()
    @StateObject private var selectViewModel = QuestionBasicViewModel()
    @ObservedObject var mainViewModel: QuestionMainViewModel
    
    @Environment(\.dismiss) var dismiss
    @State var isSaveMode: Bool
    @State private var selectedCategoryId: Int? = 0 // 0 = All
    @State private var categoryUUID = UUID()
    
    let selectedQuestionType: String

    @State var showSelectModal: Bool = false
    
    @State private var goToMain = false
    
    // 질문 선택/저장 용도
    let order: Int
    @State private var selectedQuestionId: Int? = nil

    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 28) {
                TopGroup
                CategoryGroup
                QuestionListGroup
                Spacer().frame(height: 90)
            }

            VStack {
                Spacer()
                Button(action:{
                    isSaveMode.toggle()
                    fetchQuestions(reset: true)
                }) {
                    PrimaryActionButton(
                        title: isSaveMode ? "공유한 질문 보기" : "저장한 공유질문 보기",
                        isFinished: .constant(true)
                    )
                }
                .padding(.horizontal, 21)
                Spacer().frame(height: 60)
            }
            
            // 선택 확인 모달
            if showSelectModal {
                QuestionSelectModalView(
                    isMonth: selectedQuestionType,
                    selectedQuestionId: $selectedQuestionId,
                    order: order,
                    selectedQuestionType: .OFFICIAL,
                    viewModel: selectViewModel,
                    mainViewModel: mainViewModel,
                    showSelectModal: $showSelectModal,
                    goToMain: $goToMain
                )
            }
        }
        .task {
            fetchQuestions(reset: true)
        }
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $goToMain) { TabBar(startTab: .disk) }
    }

    private var TopGroup: some View {
        VStack(alignment: .leading, spacing: 7) {
            Button(action: { dismiss() }) {
                Image(.iconBack)
            }

            Text(isSaveMode ? "Saved Questions" : "Shared Questions")
                .textStyle(.Title_Text_Eng)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }

    // 카테고리
    private var CategoryGroup: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 11) {
                ForEach(CategoryType.allCases, id: \.self) { category in
                    CategoryButton(
                        type: category,
                        selectedCategoryId: $selectedCategoryId
                    ) { id in
                        categoryUUID = UUID()
                        print("✅ 선택한 categoryId: \(id)") // 로그로 확인
                        fetchQuestions(reset: true)
                    }
                }
            }
            .padding(.horizontal, 27)
        }
        .scrollIndicators(.hidden)
    }

    // 질문 목록
    private var QuestionListGroup: some View {
        ScrollView {
            LazyVStack {
                if let list = viewModel.questionListMap[categoryUUID], !list.isEmpty {
                    ForEach(list.indices, id: \.self) { index in
                        let item = list[index]
                        QuestionShareItem(
                            type: isSaveMode ? "save" : "share",
                            category: item.categories.map { $0.categoryName }.joined(separator: ", "),
                            content: item.question,
                            date: item.createdAt,
                            sharedCount: item.sharedCount,
                            index: index + 1,
                            onTap: {
                                showSelectModal = true
                                selectedQuestionId = item.id
                            },
                            isSelected: item.isSelected,
                            selectViewModel: selectViewModel
                        )
                        .padding(.horizontal, 31)
                        .onAppear {
                            if index == list.count - 1 {
                                fetchQuestions(cursorId: item.id)
                            }
                        }
                        Spacer().frame(height: 20)
                    }
                } else {
                    Text("질문이 없습니다.")
                        .foregroundColor(.white)
                        .padding(.top, 50)
                }
            }
        }
    }

    private func fetchQuestions(reset: Bool = false, cursorId: Int? = nil) {
        if reset {
            viewModel.questionListMap[categoryUUID] = []
            viewModel.hasNextPageMap[categoryUUID] = true
        }
        if isSaveMode {
            // 저장한 공유질문 API 호출
            viewModel.fetchOfficialSavedMine(
                categoryUUID: categoryUUID,
                categoryId: selectedCategoryId,
                cursorId: cursorId,
                size: 10
            )
        } else {
            // 내가 발행한 공유질문 API 호출
            viewModel.fetchOfficialMine(
                categoryUUID: categoryUUID,
                categoryId: selectedCategoryId,
                cursorId: cursorId,
                size: 10
            )
        }
    }

}
