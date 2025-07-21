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
            
            ZStack {
                VStack(spacing: 0) {
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 0,
                        bottomLeading: 12,
                        bottomTrailing: 12,
                        topTrailing: 0))
                    .padding(.horizontal, 21)
                    .foregroundStyle(.gray400)
                    
                    Triangle()
                        .foregroundStyle(.gray400)
                        .frame(width: 93, height: 20)
                }
                
                VStack(alignment: .leading) {
                    Text("작성 질문 요약")
                        .textStyle(.Title3_Text_Ko)
                        .padding(.top, 28)
                        .padding(.leading, 51)
                    
                    Spacer().frame(height: 32)
                    
                    Text("선택한 카테고리")
                        .textStyle(.Q_Main)
                        .padding(.leading, 48)
                    
                    Spacer().frame(height: 8)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .padding(.horizontal, 21)
                            .frame(height: 60)
                            .foregroundStyle(.key)
                            .overlay(
                                VStack(spacing: 0) {
                                    Color.black000.frame(height: 1)
                                    Spacer()
                                    Color.black000.frame(height: 1)
                                }
                            )
                        Text("선택1")
                            .textStyle(.Q_Main)
                            .foregroundStyle(.black000)
                            .padding(.leading, 48)
                    }
                    
                    Spacer().frame(height: 32)
                    
                    Text("작성한 질문 내용")
                        .textStyle(.Q_Main)
                        .padding(.leading, 48)
                    Spacer().frame(height: 10)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 21)
                        Text("하루 중에 가장 에너지가 나는 시간대는 언제야?")
                            .textStyle(.Texting_Q)
                            .padding(.leading, 40)
                            .padding([.top, .bottom, .trailing], 20)
                    }
                    .padding(.horizontal, 21)
                    .padding(.bottom, 42)
                    
                }
                
                
            }
        }
    }
    
    var ButtonGroup: some View{
        VStack (spacing: 12) {
            Button(action: {
                
            }) {
                PrimaryActionButton(title: "저장하기", isFinished: .constant(true))
            }
            Button(action: {
                
            }) {
                PrimaryActionButton(title: "수정하기", isFinished: .constant(true))
            }
            Button(action: {
                
            }) {
                PrimaryActionButton(title: "공유하기", isFinished: .constant(true))
            }
            
        }
        .padding(.horizontal, 21)
        
    }
}

#Preview {
    QuestionSummaryView()
}
