//
//  QuestionShareNowView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/16/25.
//

import SwiftUI

struct QuestionShareNowView: View {
    let items = Array(0..<17)
    private let spacingAngle: Double = 19
    @State private var hiddenCount = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                InfoGroup
                Spacer()
                
                CircularScrollView
            }
            
            VStack {
                Spacer()
                PrimaryActionButton(title: "저장한 공유질문 보기", isFinished: .constant(true)) {
                    // TODO: 수정 필요
                }
                .padding(.horizontal, 21)
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var InfoGroup: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Button(action: {
                    dismiss()
                }){ // TODO: 액션 추가
                    Image(.iconBack)
                }
                .padding(.leading, 17)
                
                Spacer()
                
                NavigationLink(destination: QuestionListView(isSaveMode: false)) {
                    Image(.iconList)
                }
                .padding(.trailing, 18)
            }
            
            Text("현재 발행한 공유 질문")
                .textStyle(.Title_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 17)
            
            HStack(spacing: 6) {
                Text("17")
                    .textStyle(.Title_Text_Ko)
                    .foregroundStyle(.white)
                Text("개")
                    .textStyle(.Title_Text_Ko)
                    .foregroundStyle(.white)
            }
            .padding(.leading, 17)
            
            
            Text("사용자들과 공유한 질문들을 확인해보세요!")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 17)
        }
    }
    
    private var CircularScrollView: some View {
        GeometryReader { geometry in
            let radius = geometry.size.height / 1.2
            let center = CGPoint(x: geometry.size.width - radius * 1.4, y: geometry.size.height / 7)
            
            ZStack {
                ForEach(items.indices, id: \.self) { index in
                    if index >= hiddenCount {
                        let visibleIndex = index - hiddenCount
                        let itemAngle = Angle(degrees: Double(visibleIndex) * spacingAngle)
                        let totalAngle = itemAngle
                        
                        let x = center.x + radius * CGFloat(cos(totalAngle.radians))
                        let y = center.y + radius * CGFloat(sin(totalAngle.radians))
                        
                        QuestionShareItem(
                            type: "share",
                            category: "카테고리1",
                            content: "맛있는 음식을 먹을 때 어떤 기분이 드나요? 표현해본다면요? 맛있는 음식을 먹을 때 어떤 ",
                            date: "25년 8월 1일",
                            index: 1
                        )
                        .rotationEffect(totalAngle)
                        .position(x: x, y: y)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        
                        if value.translation.height < -threshold {
                            if hiddenCount < items.count - 1 {
                                withAnimation(.spring()) {
                                    hiddenCount += 1
                                }
                            }
                        } else if value.translation.height > threshold {
                            if hiddenCount > 0 {
                                withAnimation(.spring()) {
                                    hiddenCount -= 1
                                }
                            }
                        }
                    }
            )
            .frame(height: 636)
            
        }
        
    }
    
    
    
}



#Preview {
    QuestionShareNowView()
}
