//
//  CoreQuestionsView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/7/25.
//

import SwiftUI

struct CoreQuestionsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 3)
                
                TopMenuGroup
                
                
                Spacer().frame(height: 16)
                    
                TitleGroup
                
                ScrollView {
                    QuestionGroup
                        .padding(.top, 38)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // 상단 메뉴
    private var TopMenuGroup: some View {
        ZStack(alignment: .top) {
            Image(.imgLogoOneline)
                .padding(.top, 16)
            
            HStack(alignment: .top, spacing: 0) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.highlight)
                    .frame(width: 28, height: 55)
                    
                
                Button(action: {
                    dismiss()
                }) {
                    Image(.iconBack)
                }
                
                Spacer()
            }
            .offset(x: -14)
        }
    }
    
    // 타이틀
    private var TitleGroup: some View {
        VStack(spacing: 8) {
            HStack {
                Text("My Core Questions")
                    .textStyle(.Title_Text_Eng)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 25)
                
                Spacer()
            }
            
            Divider()
                .frame(height: 0.5)
                .background(.white)
                .padding(.horizontal, 14)
        }
    }
    
    // 질문 리스트
    private var QuestionGroup: some View {
        VStack(spacing: 68) {
            CoreQuestionList(layout: .right, category: .취향)
            CoreQuestionList(layout: .left, category: .건강)
        }
    }
}

// MARK: - Components
// 레이아웃 방향
enum CoreQuestionLayout {
    case left   // 리스트 -> CD
    case right  // CD -> 리스트
}

struct CoreQuestionList: View {
    let layout: CoreQuestionLayout
    let category: QuestionCategoryType
    
    var body: some View {
        HStack(spacing: 22) {
            if layout == .right {
                cdImage
                listView
            } else {
                listView
                cdImage
            }
        }
    }
    
    // CD
    private var cdImage: some View {
        Image(uiImage: category.cdImage)
            .resizable()
            .frame(width: 201, height: 201)
            .padding(layout == .right ? .leading : .trailing, -100)
    }
    
    // 리스트
    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(1..<10, id: \.self) { item in
                    CoreQuestionItem
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(layout == .right ? .trailing : .leading, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 190)
    }
    
    // 리스트 아이템
    private var CoreQuestionItem: some View {
        let title: String = "최근 다녀온 여행지 사진을 공유해 주세요." // TODO: API에서 불러오기
        
        return HStack(spacing: 2) {
            if layout == .right {
                Image(.iconGlobe)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.black000)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [category.startColor, category.endColor],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1
                            )
                    )
                    
                Text(title)
                    .textStyle(.login_alert)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
            }
            
            if layout == .left {
                Image(.iconGlobe)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    
}

#Preview {
    CoreQuestionsView()
}
