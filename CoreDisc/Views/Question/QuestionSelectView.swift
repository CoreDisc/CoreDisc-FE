//
//  QuestionSelectView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/19/25.
//

import SwiftUI

struct QuestionSelectView: View {
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
                
            VStack {
                TitleGroup
                
                Spacer().frame(height: 36)
                
                CDGroup
                
                Spacer()
            }
        }
    }
    
    // 상단 타이틀
    private var TitleGroup: some View {
        VStack(alignment: .leading, spacing: 1) {
            Button(action: {}) {
                Image(.iconBack)
            }
            .buttonStyle(.plain)
            
            Text("Select your own disc")
                .textStyle(.Title_Text_Eng)
                .foregroundStyle(.key)
                .padding(.leading, 6)
                .padding(.bottom, 5)
            
            Text("한달동안 함께 할 질문을 선택하세요")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 11)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 17)
    }
    
    // CD
    private var CDGroup: some View {
        ZStack(alignment: .trailing) {
            Image(.imgCd)
                .resizable()
                .frame(width: 529, height: 529)
                .offset(x: -194)
            
            VStack(spacing: 22) {
                QuestionSelectButton(title: "질문 작성")
                QuestionSelectButton(title: "기본 질문")
                QuestionSelectButton(title: "인기 질문")
                QuestionSelectButton(title: "공유 질문")
            }
            .padding(.trailing, 106)
        }
        .frame(width: UIScreen.main.bounds.width) // 화면 너비만큼만 차지
    }
}

// 질문 선택 버튼 컴포넌트
struct QuestionSelectButton: View {
    var title: String
    
    var body: some View {
        Button(action: {}) {
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
            .compositingGroup() // 하나의 뷰로 만듦 (투명도 조절에 필요)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    QuestionSelectView()
}
