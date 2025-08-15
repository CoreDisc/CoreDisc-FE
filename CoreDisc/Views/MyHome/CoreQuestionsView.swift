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
                    
                TitleGroup
                
                ScrollView {
                    QuestionGroup
                        .padding(.top, 25)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // 상단 메뉴
    private var TopMenuGroup: some View {
        ZStack(alignment: .top) {
            Image(.imgLogoOneline)
                .foregroundStyle(.white)
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
        VStack(alignment: .leading, spacing: 0) {
            Text("My Core Questions")
                .textStyle(.Title_Text_Eng)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 63)
            
            Text("작성하고 공유한 질문들을 확인해보세요.")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
            
            Spacer().frame(height: 20)
            
            Divider()
                .frame(height: 0.5)
                .background(.white)
        }
        .padding(.horizontal, 15)
    }
    
    // 질문 리스트
    private var QuestionGroup: some View {
        VStack(spacing: 50) {
            CoreQuestionList(layout: .right, category: .taste)
            CoreQuestionList(layout: .left, category: .lifeStyle)
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
    let category: CategoryType
    
    // 씨디 돌아가는 애니메이션
    @State private var rotationAngle: Double = 0.0
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
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
        let size: CGFloat = 201
        
        return Image(uiImage: category.cdImage)
            .resizable()
            .frame(width: size, height: size)
            .rotationEffect(.degrees(-rotationAngle), anchor: .center)
            .padding(layout == .right ? .leading : .trailing, -100)
            .onReceive(timer) { _ in
                withAnimation {
                    rotationAngle += 3 // 회전 속도 조절
                }
            }
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
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
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
                                category.color,
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
