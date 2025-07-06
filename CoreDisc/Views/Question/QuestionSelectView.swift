//
//  QuestionSelectView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/7/25.
//

import SwiftUI

struct QuestionSelectView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            
            BackBubbleGroup
            
            MainBubbleGroup
                
            TopGroup
        }
        .navigationBarBackButtonHidden()
    }
    
    // 버블
    private var BackBubbleGroup: some View {
        ZStack {
            Image(.imgEllipseWhite)
                .resizable()
                .frame(width: 108, height: 108)
                .position(x: 395, y: 161)
            
            Image(.imgEllipseWhite)
                .resizable()
                .frame(width: 66, height: 66)
                .position(x: 134, y: 401)
            
            Image(.imgEllipseWhite)
                .resizable()
                .frame(width: 167, height: 167)
                .position(x: 222.5, y: 791)
        }
    }
    
    private var MainBubbleGroup: some View {
        ZStack {
            QuestionBubble(
                bubble: .imgEllipsePink,
                x: 74,
                y: 267)
            QuestionBubble(
                bubble: .imgEllipseOrange,
                x: 322,
                y: 362)
            QuestionBubble(
                bubble: .imgEllipseBlue,
                x: 49.5,
                y: 610)
            QuestionBubble(
                bubble: .imgEllipseMint,
                x: 289,
                y: 602)
        }
    }
    
    // 상단 버튼 및 타이틀
    private var TopGroup: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button(action: {
                dismiss()
            }) {
                Image(.iconBack)
            }
            
            Text("Select your own disk")
                .font(.Title_Text)
                .foregroundStyle(.key)
                .kerning(-2) // 자간
            
            Text("한달동안 함께할 질문을 선택하세요")
                .font(.PrimeformSemiBold12)
                .foregroundStyle(.white)
                .kerning(-0.7)
                .padding(.leading, 5)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 23)
    }
}

// MARK: - 질문 버블 컴포넌트
struct QuestionBubble: View {
    var bubble: ImageResource
    var x: CGFloat
    var y: CGFloat
    
    var body: some View {
        Button(action: {}) { // TODO: action 추가
            ZStack {
                Image(bubble)
                    .position(x: x, y: y)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    QuestionSelectView()
}
