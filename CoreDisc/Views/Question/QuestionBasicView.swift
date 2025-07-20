//
//  QuestionBasicView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct QuestionBasicView: View {
    private var viewModel: QuesitonBasicViewModel = .init()
    
    @Environment(\.dismiss) var dismiss
    @State var showModal: Bool = false
    
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
                            .textStyle(.Button_s)
                        
                        Text("한번 설정한 고정질문은 30일간 변경이 불가능합니다.")
                            .textStyle(.Button_s)
                            .foregroundStyle(.red)
                    }
                } leftButton: {
                    Button(action: {
                        showModal.toggle() // 모달 제거
                        // TODO: question select api
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
        List {
            ForEach(viewModel.categoryItem) { item in
                QuestionBasicCategoryItem(
                    title: item.title,
                    count: 99,
                    startColor: item.startColor,
                    endColor: item.endColor
                )
                .onTapGesture {
                    withAnimation {
                        toggleExpanded(for: item.id)
                    }
                }
                
                if expandedCategoryIDs.contains(item.id) {
                    ForEach(0..<10, id: \.self) { index in
                        QuestionBasicDetailItem(
                            showModal: $showModal,
                            title: "\(item.title) \(index + 1)",
                            startColor: item.startColor,
                            endColor: item.endColor
                        )
                    }
                }
            }
            .listRowSeparator(.hidden) // 구분선 제거
            .listRowBackground(Color.clear) // 리스트 기본 색상 제거
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 21))
        }
        .listStyle(.plain) // list 주변영역 제거
        .listRowSpacing(24) // 리스트 간격
        .scrollContentBackground(.visible) // 기본 배경 색상 제거
        .padding(.leading, 21)
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
    
    var body: some View {
        Button(action: {
            showModal.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.shadow(.inner(
                        color: .shadow,
                        radius: 6,
                        y: -4
                    )))
                    .linearGradient(
                        startColor: startColor,
                        endColor: endColor)
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
    QuestionBasicView()
}
