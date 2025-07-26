//
//  QuestionListView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/20/25.
//

import SwiftUI

struct QuestionListView: View {
    @Environment(\.dismiss) var dismiss
    @State var isSaveMode: Bool
    let items = Array(0..<17)
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                TopGroup
                CategoryGroup
                QuestionListGroup
            }
            
            VStack {
                Spacer()
                Button(action:{
                    isSaveMode.toggle()
                }) {
                    PrimaryActionButton(
                        title: isSaveMode ? "공유한 질문 보기" : "저장한 공유질문 보기",
                        isFinished: .constant(true)
                    )
                }
                .padding(.horizontal, 21)
            }
        }
        .navigationBarBackButtonHidden()
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
    
    //카테고리
    private var CategoryGroup: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 11) {
                if isSaveMode {
                    ForEach(CategoryType.allCases, id: \.self) { category in
                        CategoryButton(type: category)
                    }
                } else {
                    ForEach(CategoryType.allCases.filter { $0 != .favorite }, id: \.self) { category in
                        CategoryButton(type: category)
                    }
                }
            }
            .padding(.horizontal, 27)
        }
        .scrollIndicators(.hidden)
    }
    
    //질문 목록
    private var QuestionListGroup: some View {
        ScrollView {
            LazyVStack {
                ForEach(items.indices, id: \.self) { index in
                    QuestionShareItem(
                        type: isSaveMode ? "save" : "share",
                        category: "감정,마음",
                        content: "맛있는 음식을 먹을 때 어떤 기분이 드나요? 표현해본다면요? 맛있는 음식을 먹을 때 어떤",
                        date: "26년 7월 4일",
                        index: index + 1
                    )
                    .padding(.horizontal, 31)
                    Spacer().frame(height: 20)
                    
                }
            }
            
        }
    }
}

#Preview {
    QuestionListView(isSaveMode: false)
}
