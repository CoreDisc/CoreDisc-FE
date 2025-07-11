//
//  QuestionShareView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct QuestionShareView: View {
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
        }
    }
    
    // 상단 뷰
    private var TopGroup: some View {
        VStack(alignment: .leading, spacing: 7) {
            Button(action: {}) { // TODO: 액션 추가
                Image(.iconBack)
            }
            
            Text("Shared Questions")
                .textStyle(.Title_Text_Eng)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
    
    // 카테고리
    private var CategoryGroup: some View {
        ScrollView(.horizontal) {
            HStack {
                CategoryButton(
                    title: "카테고리1",
                    startColor: .blue1,
                    endColor: .blue2)
            }
            .padding(.horizontal, 27)
        }
    }
    
    // 질문 목록
    private var QuestionListGroup: some View {
        ScrollView {
            LazyVStack(alignment: .center) {
                QuestionShareItem(
                    category: "감정,마음",
                    content: "맛있는 음식을 먹을 때 어떤 기분이 드나요? 표현 해본다면요? 맛있는 음식을 먹을 때 어떤 기분이 드나요? 표현 해본다면요?",
                    date: "26년 7월 4일"
                    )
            }
        }
    }
}

// 공유 질문 아이템
struct QuestionShareItem: View {
    var category: String
    var content: String
    var date: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .key, radius: 2, x: 0, y: 0)
            
            VStack(spacing: 5) {
                HStack {
                    Text("1") // 디자인 시스템 없음
                        .font(.pretendard(type: .bold, size: 12))
                        .frame(width: 20, height: 20)
                        .background(
                            Circle()
                                .fill(.highlight)
                        )
                    
                    Spacer()
                    
                    Button(action: {}) { // TODO: action
                        Image(.iconClose)
                    }
                }
                
                Text(content)
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.black)
                
                Spacer().frame(height: 14)
                
                HStack(spacing: 5) {
                    Spacer()
                    
                    Text(category) // 디자인 시스템 없음
                        .font(.pretendard(type: .regular, size: 8))
                        .kerning(-0.7)
                    
                    Text(date) // 디자인 시스템 없음
                        .font(.pretendard(type: .regular, size: 8))
                        .kerning(-0.7)
                }
            }
            .padding(.horizontal, 11)
        }
        .frame(width: 340, height: 115)
    }
}

#Preview {
    QuestionShareView()
}
