//
//  QuestionMainView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct QuestionMainView: View {
    @State var isSelectView: Bool = false
    
    // 씨디 돌아가는 애니메이션
    @State private var rotationAngle: Double = 0.0
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.imgShortBackground)
                    .resizable()
                    .ignoresSafeArea()
                    
                VStack {
                    TitleGroup
                    
                    Spacer().frame(height: 36)
                    
                    MainCDGroup
                    
                    Spacer()
                }
            }
        }
    }
    
    // 상단 타이틀
    private var TitleGroup: some View {
        VStack(alignment: .leading, spacing: 1) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.4)) {
                    isSelectView = false
                }
            }) {
                Image(.iconBack)
            }
            .buttonStyle(.plain)
            .opacity(isSelectView ? 1 : 0) // select일 때만 보이게
            
            Text(isSelectView ? "Select your own disc" : "Today’s Coredisc")
                .textStyle(.Title_Text_Eng)
                .foregroundStyle(.key)
                .padding(.leading, 6)
                .padding(.bottom, 5)
            
            Text(isSelectView ? "한달동안 함께 할 질문을 선택하세요" : "오늘의 코어디스크를 기록해보세요")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 11)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 17)
    }
    
    // CD, QuestionSelectItem
    // TODO: CD 애니메이션 적용
    private var MainCDGroup: some View {
        ZStack {
            Image(.imgCd)
                .resizable()
                .frame(width: 529, height: 529)
                .rotationEffect(.degrees(-rotationAngle))
                .onReceive(timer) { _ in
                    withAnimation {
                        rotationAngle += 1 // 회전 속도 조절
                    }
                }
                .offset(x: 172)
            
            QuestionSelectItem(moveLeft: $isSelectView, text: "고정질문을 선택하세요")
                .position(x: 150+79, y: 97)
            
            QuestionSelectItem(moveLeft: $isSelectView, text: "고정질문을 선택하세요")
                .position(x: 150+34, y: 196)
            
            QuestionSelectItem(moveLeft: $isSelectView, text: "고정질문을 선택하세요")
                .position(x: 150+42, y: 295)
            
            QuestionSelectItem(moveLeft: $isSelectView, text: "랜덤질문을 선택하세요")
                .position(x: 150+79, y: 394)
            
            SelectCDGroup
                .offset(x: 460)
        }
        .frame(width: UIScreen.main.bounds.width, height: 529)
        .offset(x: isSelectView ? -366 : 0)
    }
    
    private var SelectCDGroup: some View {
        VStack(spacing: 22) {
            QuestionSelectButton(title: "질문 작성", destination: { AnyView(QuestionWriteView()) })
            QuestionSelectButton(title: "기본 질문", destination: { AnyView(QuestionBasicView()) })
            QuestionSelectButton(title: "인기 질문", destination: nil)
            QuestionSelectButton(title: "공유 질문", destination: { AnyView(QuestionShareNowView()) })
        }
        .offset(x: 0)
    }
}

// 질문 선택 컴포넌트
struct QuestionSelectItem: View {
    @Binding var moveLeft: Bool
    
    var text: String
    var startColor: Color = .gray400
    var endColor: Color = .gray400
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.4)) {
                moveLeft = true
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white.gradient.shadow(.inner(color: .shadow, radius: 2, y: -2))) // 내부 그림자
                    .frame(width: 210, height: 48)
                
                HStack(spacing: 8) {
                    Circle()
                        .linearGradient(startColor: startColor, endColor: endColor)
                        .frame(width: 27)
                    
                    Text(text)
                        .textStyle(.Q_pick)
                        .foregroundStyle(.black000)
                        .frame(width: 143, alignment: .leading)
                        .lineLimit(1)
                }
            }
        }
    }
}

// 질문 선택 버튼 컴포넌트
struct QuestionSelectButton: View {
    var title: String
    var destination: (() -> AnyView)?
    
    var body: some View {
        if let destination = destination {
            NavigationLink(destination: destination()) {
                buttonContent
            }
            .buttonStyle(.plain)
        } else {
            buttonContent
        }
    }

    private var buttonContent: some View {
        ZStack(alignment: .top) {
            Image(.imgCd)
                .resizable()
                .frame(width: 76, height: 76)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 4)
                    .horizontalLinearGradient(startColor: .white, endColor: .gray400)
                    .frame(width: 98, height: 68)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)

                Text(title)
                    .textStyle(.Q_Main)
                    .foregroundStyle(.black000)
                    .padding(.top, 10)
                    .padding(.leading, 9)
            }
            .padding(.top, 38)
        }
        .compositingGroup()
    }
}

#Preview {
    QuestionMainView()
}
