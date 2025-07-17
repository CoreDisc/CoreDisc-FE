//
//  QuestionShareNowView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/16/25.
//

import SwiftUI

struct QuestionShareNowView: View {
    let items = Array(0..<11)
    @State private var selectedIndex = 0
    @State private var currentAngle: Angle = .degrees(0)
    @GestureState private var dragAngle: Angle = .zero
    @GestureState private var dragOffset: CGFloat = 0
    private let spacingAngle: Double = 19
    @State private var hiddenCount = 0
    
    
    
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
        }
    }
    
    private var InfoGroup: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Button(action: { }){ // TODO: 액션 추가
                    Image(.iconBack)
                }
                .padding(.leading, 17)
                
                Spacer()
                
                Button(action: { }) { // TODO: 액션 추가
                    Image(.iconList)
                }
                .padding(.trailing, 18)
            }
            
            Text("현재 발행한 공유 질문")
                .textStyle(.Title_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 17)
            
            HStack(spacing: 6) {
                Text("10")
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

                        QuestionShareItemm(
                            category: "카테고리\(index)",
                            content: "맛있는 걸 먹을 때 어떤 기분이 드나요?",
                            date: "25년 7월 16일",
                            index: index
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
    
    struct QuestionShareItemm: View {
        var category: String
        var content: String
        var date: String
        let index: Int
        
        
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
                        .foregroundStyle(.black000)
                    
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
}


#Preview {
    QuestionShareNowView()
}
