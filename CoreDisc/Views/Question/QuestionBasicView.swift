//
//  QuestionBasicView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct QuestionBasicView: View {
    @StateObject private var viewModel = QuestionBasicViewModel()
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    private let topAnchorID = "top" // 스크롤 초기화 용도
    
    @State var showSelectModal: Bool = false
    @State var showSaveModal: Bool = false
    
    // 질문 선택/저장 용도
    let order: Int
    @State private var selectedQuestionId: Int? = nil
    @State private var selectedQuestionType: String? = nil
    
    // 열려있는 카테고리
    @State private var expandedCategoryIDs: Set<UUID> = []
    
    // 검색
    @State private var searchText: String = ""
    private var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
                .onTapGesture { // 키보드 내리기 용도
                    isFocused = false
                }
            
            VStack(spacing: 21) {
                TopGroup
                
                searchGroup
                
                if isSearching {
                    categoryGroup(isSearching: true, keyword: searchText)
                } else {
                    categoryGroup(isSearching: false, keyword: nil)
                }
            }
            
            // 선택 확인 모달
            if showSelectModal {
                ModalView {
                    VStack(spacing: 6) {
                        Text("\(selectedQuestionType == "FIXED" ? "고정" : "랜덤")질문으로 선택할까요?")
                            .textStyle(.Button)
                        
                        Text("한번 설정한 고정질문은 \(selectedQuestionType == "FIXED" ? "30일간" : "하루동안") 변경이 불가능합니다.")
                            .textStyle(.Texting_Q)
                            .foregroundStyle(.red)
                    }
                } leftButton: {
                    Button(action: {
                        guard let questionId = selectedQuestionId,
                              let type = selectedQuestionType else { return }
                        
                        if type == "FIXED" {
                            let data = FixedData(
                                selectedQuestionType: .DEFAULT,
                                questionOrder: order,
                                questionId: questionId
                            )
                            viewModel.fetchFixedBasic(fixedData: data)
                        } else {
                            let data = RandomData(
                                selectedQuestionType: .DEFAULT,
                                questionId: questionId
                            )
                            viewModel.fetchRandomBasic(randomData: data)
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
            
            // 저장 확인 모달
            if showSaveModal {
                ModalView {
                    VStack(spacing: 6) {
                        Text("해당 질문을 저장할까요?")
                            .textStyle(.Button)
                        
                        Text("저장한 질문은 저장한 공유질문 보기에서 확인할 수 있습니다.")
                            .textStyle(.Texting_Q)
                            .foregroundStyle(.gray600)
                    }
                } leftButton: {
                    Button(action: {
                        viewModel.fetchOfficialSave(questionId: selectedQuestionId!)
                        showSaveModal.toggle() // 모달 제거
                    }) {
                        Text("저장하기")
                    }
                } rightButton: {
                    Button(action: {
                        showSaveModal.toggle() // 모달 제거
                    }) {
                        Text("뒤로가기")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
        .task {
            viewModel.fetchCategories()
        }
        .task(id: searchText) {
            let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            viewModel.fetchSearchCategories(keyword: keyword)
        }
    }
    
    // MARK: - group
    
    // 상단 타이틀
    private var TopGroup: some View {
        ZStack(alignment: .top) {
            Image(.imgLogoOneline)
                .padding(.top, 19)
            
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
            
            HStack {
                Image(.iconSearchWhite)
                
                TextField("", text: $searchText)
                    .textStyle(.Q_Main)
                    .foregroundStyle(.white)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .focused($isFocused)
                
                Button(action: {
                    searchText = ""
                }) {
                    Image(.iconClose)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 14)
        }
        .padding(.horizontal, 25)
    }
    
    // 카테고리 목록
    private func categoryGroup(
        isSearching: Bool,
        keyword: String?
    ) -> some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                List {
                    Section {
                        // 개수 0개면 안 보이게
                        let categories = (isSearching ? viewModel.searchCategoryItem : viewModel.categoryItem)
                            .filter { $0.count > 0 }
                        
                        ForEach(categories) { item in
                            QuestionBasicCategoryItem(
                                title: item.title,
                                count: item.count,
                                startColor: item.startColor,
                                endColor: item.endColor
                            )
                            .onTapGesture {
                                withAnimation {
                                    toggleExpanded(for: item.id)
                                    if isSearching, let keyword {
                                        viewModel.fetchBasicListsSearch(
                                            categoryUUID: item.id,
                                            categoryId: item.categoryId,
                                            keyword: keyword
                                        )
                                    } else {
                                        viewModel.fetchBasicLists(
                                            categoryUUID: item.id,
                                            categoryId: item.categoryId
                                        )
                                    }
                                }
                            }
                            
                            if expandedCategoryIDs.contains(item.id) {
                                let questionList = isSearching
                                ? (viewModel.searchQuestionListMap[item.id] ?? [])
                                : (viewModel.questionListMap[item.id] ?? [])
                                
                                ForEach(Array(questionList.enumerated()), id: \.element.id) { index, question in
                                    QuestionBasicDetailItem(
                                        showSelectModal: $showSelectModal,
                                        showSaveModal: $showSaveModal,
                                        isSelected: question.isSelected,
                                        isFavorite: question.isFavorite,
                                        title: question.question,
                                        startColor: item.startColor,
                                        endColor: item.endColor,
                                        questionId: question.id,
                                        questionType: question.questionType,
                                        onSelect: { id, type in
                                            selectedQuestionId = id
                                            selectedQuestionType = type
                                        }
                                    )
                                    .task {
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
                        
                        Color.clear
                            .frame(height: 40)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
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
                .padding(.bottom, 60)
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
    }
}

// 질문 상세
struct QuestionBasicDetailItem: View {
    @Binding var showSelectModal: Bool
    @Binding var showSaveModal: Bool
    
    var isSelected: Bool
    var isFavorite: Bool
    
    var title: String
    var startColor: Color
    var endColor: Color
    
    var questionId: Int
    var questionType: String
    var onSelect: (Int, String) -> Void
    
    @State private var isShifted: Bool = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                isShifted.toggle()
            }
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
            .offset(x: isShifted ? 131 : 0)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .leading) {
            HStack(spacing: 3) {
                Button {
                    showSelectModal.toggle()
                    onSelect(questionId, questionType)
                } label: {
                    Image(isSelected ? .iconBasicSelected : .iconBasicSelect)
                }
                
                Button {
                    showSaveModal.toggle()
                    onSelect(questionId, questionType)
                } label: {
                    Image(isFavorite ? .iconBasicSaved : .iconBasicSave)
                }
                
                Spacer().frame(width: 13)
            }
            .offset(x: isShifted ? 0 : -131)
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    QuestionBasicView(order: 1)
}
