//
//  QuestionMainView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct QuestionMainView: View {
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
                
            VStack {
                Spacer().frame(height: 23)
                
                TitleGroup
                
                Spacer().frame(height: 61)
                
                CDGroup
                
                Spacer().frame(height: 78)
                
                BottomGroup
            }
        }
    }
    
    // 상단 타이틀
    private var TitleGroup: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Today’s Coredisc")
                .font(.Title_Text)
                .foregroundStyle(.key)
                .kerning(-2) // 자간
            
            Text("오늘의 코어디스크를 기록해보세요")
                .font(.PrimeformSemiBold12)
                .foregroundStyle(.white)
                .kerning(-0.7)
                .padding(.leading, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 23)
    }
    
    // CD, QuestionSelectItem
    private var CDGroup: some View {
        ZStack {
            Image(.imgCd)
                .resizable()
                .frame(width: 479, height: 479)
                .offset(x: 150)
            
            QuestionSelectItem(text: "고정질문을 선택하세요")
                .position(x: 150+79, y: 97)
            
            QuestionSelectItem(text: "고정질문을 선택하세요")
                .position(x: 150+34, y: 196)
            
            QuestionSelectItem(text: "고정질문을 선택하세요")
                .position(x: 150+42, y: 295)
            
            QuestionSelectItem(text: "랜덤질문을 선택하세요")
                .position(x: 150+79, y: 394)
        }
        .frame(width: UIScreen.main.bounds.width)
    }
    
    // 뒤로가기, SET 버튼
    private var BottomGroup: some View {
        HStack {
            Button(action: {}) {
                ZStack {
                    Circle()
                        .stroke(.key, lineWidth: 2)
                        .frame(width: 60)
                    
                    Image(.iconBack)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                ZStack {
                    Circle()
                        .stroke(.key, lineWidth: 2)
                        .frame(width: 60)
                    
                    Text("SET")
                        .font(.PrimeformBold16)
                        .foregroundStyle(.key)
                }
            }
        }
        .padding(.horizontal, 35)
    }
}

// 질문 선택 컴포넌트
struct QuestionSelectItem: View {
    var text: String
    var startColor: Color = .grayText
    var endColor: Color = .grayText
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.white.gradient.shadow(.inner(color: .shadow, radius: 2, y: -2))) // 내부 그림자
                .frame(width: 210, height: 48)
            
            HStack(spacing: 8) {
                Circle()
                    .linearGradient(startColor: startColor, endColor: endColor)
                    .frame(width: 27)
                
                Text(text)
                    .font(.PretendardRegular12)
                    .frame(width: 143, alignment: .leading)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    QuestionMainView()
}
