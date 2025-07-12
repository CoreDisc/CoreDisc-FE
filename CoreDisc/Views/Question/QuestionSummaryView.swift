//
//  QuestionSummaryView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/13/25.
//

import SwiftUI

struct QuestionSummaryView: View {
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            VStack {
                QuestionSummaryGroup
                Spacer().frame(height: 14)
                ButtonGroup
            }
        }
    }
    
    var QuestionSummaryGroup: some View {
        VStack {
            HStack {
                Button(action: {}){
                    Image(.iconBack)
                }
                .padding(.leading, 17)
                Spacer()
            }
            
            Spacer().frame(height: 23)
            
            ZStack(alignment: .topLeading){
                VStack(spacing: 0) {
                    Group {
                        UnevenRoundedRectangle(cornerRadii: .init(
                            topLeading: 0,
                            bottomLeading: 12,
                            bottomTrailing: 12,
                            topTrailing: 0))
                        .frame(width: 360, height: 441)
                        .foregroundStyle(.grayText)
                        
                        Triangle()
                            .foregroundStyle(.grayText)
                            .frame(width: 93, height: 20)
                    }
                }
                VStack (alignment: .leading){
                    Text("작성 질문 요약")
                        .textStyle(.Title3_Text_Ko)
                        .padding(.top, 28)
                        .padding(.leading, 30)
                    
                    Spacer().frame(height: 32)
                    
                    Text("선택한 카테고리")
                        .textStyle(.Q_Main)
                        .padding(.leading, 27)
                    
                    Spacer().frame(height: 8)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: 360, height: 60)
                            .foregroundStyle(.key)
                            .overlay(
                                VStack(spacing: 0) {
                                    Color.black.frame(height: 1)
                                    Spacer()
                                    Color.black.frame(height: 1)
                                }
                            )
                        Text("선택1")
                            .textStyle(.Q_Main)
                            .foregroundStyle(.black)
                            .padding(.leading, 27)
                    }
                    
                    Spacer().frame(height: 32)
                    
                    Text("작성한 질문 내용")
                        .textStyle(.Q_Main)
                        .padding(.leading, 27)
                    Spacer().frame(height: 10)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.white)
                            .frame(width: 320, height: 160)
                            .padding(.leading, 20)
                        Text("하루 중에 가장 에너지가 나는 시간대는 언제야?")
                            .textStyle(.Texting_Q)
                            .padding(.leading, 40)
                            .padding([.top, .bottom, .trailing], 20)
                    }
                    
                }
                
                
            }
        }
    }
    
    var ButtonGroup: some View{
        VStack (spacing: 12) {
            PrimaryActionButton(title: "저장하기", isFinished: .constant(true))
            PrimaryActionButton(title: "수정하기", isFinished: .constant(false))
            PrimaryActionButton(title: "공유하기", isFinished: .constant(false))
            
        }
        
    }
}

#Preview {
    QuestionSummaryView()
}
