//
//  CoreQuestionsView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/7/25.
//

import SwiftUI

struct CoreQuestionsView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = CoreQuestionsViewModel()
    
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
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            for id in 1...10 {
                viewModel.fetchCoreQuestions(categoryId: id)
            }
        }
        // 하위에서 viewModel 접근할 수 있게
        .environmentObject(viewModel)
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
    
    // 리스트 필터링
    private var filterQuestion: [(id: Int, items: [CoreQuestionValue])] {
        (1...10).compactMap { id in
            let items = viewModel.questionList[id] ?? []
            return items.isEmpty ? nil : (id, items)
        }
    }
    
    // 질문 리스트
    private var QuestionGroup: some View {
        VStack(spacing: 50) {
            ForEach(Array(filterQuestion.enumerated()), id: \.element.id) { index, item in
                CoreQuestionList(
                    layout: index.isMultiple(of: 2) ? .right : .left,
                    categoryId: item.id,
                    items: item.items
                )
            }
        }
        .padding(.bottom, 75)
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
    let categoryId: Int
    let items: [CoreQuestionValue]
    
    // 씨디 돌아가는 애니메이션
    @State private var rotationAngle: Double = 0.0
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    private var category: CategoryType {
        CategoryType.fromId(categoryId) ?? .other
    }
    
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
                ForEach(items, id: \.id) { item in
                    HStack(spacing: 2) {
                        if layout == .right {
                            Image(.iconGlobe)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(item.isShared ? .key : .gray600)
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
                                
                            Text(item.question)
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
                                .foregroundStyle(item.isShared ? .key : .gray600)
                        }
                    }
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
}

#Preview {
    CoreQuestionsView()
}
