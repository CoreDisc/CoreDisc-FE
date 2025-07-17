//
//  QuestionShareNowView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/16/25.
//

import SwiftUI

struct QuestionShareNowView: View {
    let items = Array(0..<6)
    @State private var angle: Angle = .degrees(-90)
    @GestureState private var dragAngle: Angle = .zero

    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()

            VStack {
                InfoGroup
                Spacer()
                
                //CircularScrollView
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
    
//    private var CircularScrollView: some View {
//        GeometryReader { geometry in
//            let radius = geometry.size.height / 1.2
//            let center = CGPoint(x: geometry.size.width - radius * 1.40, y: geometry.size.height / 5)
//    
//
//            ZStack {
//                ForEach(items.indices, id: \.self) { index in
//                    let spacingAngle: Double = 18
//                    let itemAngle = Angle(degrees: Double(index) * spacingAngle)
//                    let totalAngle = itemAngle + angle + dragAngle
//
//                    let x = center.x + radius * CGFloat(cos(totalAngle.radians))
//                    let y = center.y + radius * CGFloat(sin(totalAngle.radians))
//
//
//                    QuestionShareItemm(
//                        category: "카테고리1",
//                        content: "맛있는 걸 먹을 때 어떤 기분이 드나요?",
//                        date: "25년 7월 16일",
//                        index: index
//                    )
//                    .rotationEffect(totalAngle)
//                    .position(x: x, y: y)
//                }
//
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .gesture(
//                DragGesture()
//                    .updating($dragAngle) { value, state, _ in
//                        state = Angle(degrees: Double(value.translation.height) / 2)
//                    }
//                    .onEnded { value in
//                        angle += Angle(degrees: Double(value.translation.height) / 2)
//                    }
//            )
//        }
//        .frame(height: 636)
//
//    }
    
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



#Preview {
    QuestionShareNowView()
}
