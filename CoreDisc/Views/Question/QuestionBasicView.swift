//
//  QuestionBasicView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct QuestionBasicView: View {
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
        }
    }
    
    // 상단 타이틀
    private var TopGroup: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button(action: {}) { // TODO: 액션 추가
                Image(.iconBack)
            }
            
            Text("Select your own disc")
                .textStyle(.Title_Text_Eng)
                .foregroundStyle(.key)
            
            Text("한 달동안 함께할 질문을 설정하세요.")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 23)
    }
    
    // 검색창
    private var searchGroup: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 22.5)
                .foregroundStyle(.tabDark)
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
        ScrollView {
            VStack(spacing: 24) {
                QuestionBasicCategoryItem(
                    title: "식사",
                    count: 99,
                    startColor: .yellow1,
                    endColor: .yellow2)
            }
        }
    }
}

// 질문 카테고리
struct QuestionBasicCategoryItem: View {
    var title: String
    var count: Int
    var startColor: Color
    var endColor: Color
    
    var body: some View {
        Button(action: {
            print("click")
        }) {
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
        .padding(.horizontal, 21)
    }
}

#Preview {
    QuestionBasicView()
}
