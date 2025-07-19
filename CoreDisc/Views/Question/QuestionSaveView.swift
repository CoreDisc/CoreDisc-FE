//
//  QuestionSaveView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/19/25.
//

import SwiftUI

struct QuestionSaveView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isSelected: Bool = false
    let onNavigateToShare: () -> Void
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
                    PrimaryActionButton(title: "공유한 질문 보기", isFinished: .constant(true)) {
                        onNavigateToShare()
                    }
                }
            }
            .navigationBarBackButtonHidden()
        
    }
    
    // 상단 뷰
    private var TopGroup: some View {
        VStack(alignment: .leading, spacing: 7) {
            Button(action: {
                dismiss()
            }) { // TODO: 액션 추가
                Image(.iconBack)
            }
            
            Text("Saved Questions")
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
                Button(action: {
                    isSelected.toggle()
                }) { //TODO: Action 추가
                    ZStack {
                        EllipticalGradient(
                            stops: [
                                .init(color: .gray400.opacity(0.0), location: 0.2692),
                                .init(color: .white, location: 0.8125)
                            ],
                            center: .center,
                            startRadiusFraction: 0,
                            endRadiusFraction: 0.7431
                        )
                        .frame(width: 75, height: 28)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.white, lineWidth: isSelected ? 3 : 0)
                        )

                        Text("ALL")
                            .textStyle(.Q_Sub)
                            .foregroundStyle(.white)
                    }
                }
                CategoryButton(
                    title: "즐겨찾기",
                    startColor: .key,
                    endColor: .gray700) //TODO: 색상 그라데이션, 크기 추후 수정 필요
                
                CategoryButton(
                    title: "카테고리1",
                    startColor: .blue1,
                    endColor: .blue2)
                CategoryButton(
                    title: "카테고리1",
                    startColor: .purple1,
                    endColor: .purple2)
                CategoryButton(
                    title: "카테고리1",
                    startColor: .pink1,
                    endColor: .pink2)
            }
            .padding(.horizontal, 27)
        }
        .scrollIndicators(.hidden)
    }
    
    // 질문 목록
    private var QuestionListGroup: some View {
        ScrollView {
            LazyVStack(alignment: .center) {
                ForEach(items.indices, id: \.self) { index in
                    QuestionShareItem(
                        type: "save",
                        category: "감정,마음",
                        content: "맛있는 음식을 먹을 때 어떤 기분이 드나요? 표현해본다면요? 맛있는 음식을 먹을 때 어떤 ",
                        date: "26년 7월 4일",
                        index: index + 1
                    )
                    Spacer().frame(height: 20)
                }
            }
        }
    }
}


#Preview {
    QuestionSaveView(onNavigateToShare: {})
}


