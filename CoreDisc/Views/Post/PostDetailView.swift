//
//  PostDetailView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/3/25.
//

import SwiftUI

struct PostDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Image(.imgPostDetailBg)
                .resizable()
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    BackButtonGroup
                    
                    Spacer().frame(height: 9)
                    
                    AnswerGroup
                    
                    Spacer().frame(height: 20)
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color.highlight)
                        .padding(.horizontal, 30)
                    
                    Spacer().frame(height: 20)
                    
                    VStack(spacing: 27) {
                        TodaysDiscGroup
                        
                        Divider()
                            .frame(height: 1)
                            .background(Color.highlight)
                            .padding(.horizontal, 30)
                        
                        ReportSlideGroup
                        
                        ReportGroup
                        
                        BottomGroup
                    }
                }
            }
        }
    }
    
    // 뒤로가기 버튼 섹션
    private var BackButtonGroup: some View {
        HStack{
            Button(action: {
                dismiss()
            }){
                Image(.iconBack)
                    .resizable()
                    .frame(width: 42, height: 42)
            }
            
            Spacer()
        }
        .padding(.leading, 17)
    }
    
    // 답변 섹션
    private var AnswerGroup: some View {
        VStack(alignment: .center, spacing: 8) {
            ZStack(alignment: .center) {
                // 추후 답변 사진으로 변경
                Rectangle()
                    .frame(width: 217.6, height: 380)
                    .cornerRadius(17.71)
                    .foregroundStyle(.red)
                    .offset(y: 0)
                    .zIndex(0)
                
                Rectangle()
                    .frame(width: 230.4, height: 380)
                    .cornerRadius(18.75)
                    .foregroundStyle(.orange)
                    .offset(y: 9)
                    .zIndex(1)
                
                Rectangle()
                    .frame(width: 243.2, height: 380)
                    .cornerRadius(19.79)
                    .foregroundStyle(.yellow)
                    .offset(y: 18)
                    .zIndex(2)
                
                Rectangle()
                    .frame(width: 256, height: 380)
                    .cornerRadius(20.83)
                    .foregroundStyle(.green)
                    .offset(y: 27)
                    .zIndex(3)
            }
            
            Spacer().frame(height:27)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    Text("계절마다 떠오르는 음식이 있나요? 요즘 \n생각나는 건 뭐예요?")
                        .textStyle(.Q_Main)
                        .foregroundStyle(.black000)
                        .padding(.vertical, 6)
                        .padding(.trailing, 5)
                    
                    Button(action: {
                    }){
                        Image(.iconLove)
                            .resizable()
                            .frame(width: 25.08, height: 25.08)
                            .padding(.top,4)
                            .padding(.leading, 3.19)
                    }
                    
                    Button(action: {
                    }){
                        Image(.iconMessage)
                            .resizable()
                            .frame(width: 25.08, height: 25.08)
                            .padding(.top,4.18)
                            .padding(.leading, 2.09)
                    }
                }
                
                HStack(spacing: 4) {
                    // 추후 프로필 사진으로 변경
                    Circle()
                        .frame(width: 24, height: 24)
                    
                    Text("@coredisc.ko")
                        .textStyle(.Post_Id)
                        .foregroundStyle(.gray800)
                }
            }
            .padding(.horizontal)
        }
    }
    
     // Today's Disc 섹션
     private var TodaysDiscGroup: some View {
         VStack(alignment: .leading, spacing: 16){
             Text("Today’s disc")
                 .textStyle(.Post_Title)
                 .foregroundStyle(.black000)
                 .frame(width: 120, height: 43)
             
             VStack(alignment: .leading, spacing: 19) {
                 QuestionText(question: "계절마다 떠오르는 음식이 있나요? 요즘 생각나는 건 뭐예요?")
                 
                 QuestionText(question: "마지막으로 들은 음악은 무엇인가요?")
                 
                 QuestionText(question: "취향이 반영된 콘텐츠 추천 하나 해주신다면요?")
                 
                 QuestionText(question: "감정이 흔들렸던 대사나 장면이 기억나시나요?")
             }
         }
         .padding(.top, 20)
         .padding(.bottom, 27)
         .padding(.horizontal, 22)
         
     }
     

    // 선택형 일기 슬라이드 버튼 섹션
    private var ReportSlideGroup: some View {
        HStack(alignment: .center, spacing: 6){
            ForEach(0...3, id: \.self) { index in
                Button(action: {
                }) {
                    Image(.iconPostSlide)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
        }
    }

    
     // 선택형 일기 섹션
    private var ReportGroup: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(.key)
                .cornerRadius(12)
                .frame(width: 344, height:514)
            
            VStack {
                Spacer().frame(height: 23)
                
                Text("coredisc")
                    .textStyle(.Post_Sub)
                    .foregroundStyle(.white)
                    .frame(width: 53, height: 42, alignment: .center)
                
                Text("coredisc.ko")
                    .textStyle(.Title_Text_Ko)
                    .foregroundStyle(.black000)
                    .frame(width:180, height: 43, alignment: .center)
                    .offset(y: -20)
                
                //Spacer().frame(height: 19)
                
                ZStack {
                    Circle()
                        .frame(width: 270,height: 270)
                        .cornerRadius(270)
                        .foregroundStyle(.white)
                    
                    VStack {
                        Text("Who ?")
                            .textStyle(.Pick_Q_Eng)
                            .foregroundStyle(.black000)
                        
                        Spacer().frame(height: 62)
                        
                        Text("친구")
                            .textStyle(.A_Main)
                            .foregroundStyle(.black000)
                    }
                    .frame(width: 218, height: 107)
                    .padding(.top, 35)
                    .padding(.bottom,118)
                }
                
                Spacer().frame(height: 19)
                
                HStack (alignment: .center, spacing: 19) {
                    Button(action:{})
                    {
                        Image(.iconPlayBack)
                            .resizable()
                            .frame(width:44, height: 44)
                    }
                    
                    Button(action:{})
                    {
                        Image(.iconPlay)
                            .resizable()
                            .frame(width:44, height: 44)
                    }
                    
                    Button(action:{})
                    {
                        Image(.iconPlayNext)
                            .resizable()
                            .frame(width:44, height: 44)
                    }
                    
                }
                Spacer().frame(height: 3)
                
                Text("25 : 06 : 06")
                    .textStyle(.Post_Time)
                    .foregroundStyle(.black000)
                    .frame(width:106, height: 42, alignment: .center)
            }
        }
        .padding(.bottom, 33)
    }
    
    // 하단 뷰
    private var BottomGroup: some View {
        VStack {
            Rectangle()
                .frame(height: 68)
                .foregroundStyle(.gray600)
        }
    }
}

// 사용자 4가지 질문 컴포넌트
struct QuestionText: View {
    var question: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .cornerRadius(32)
                .frame(width: 300, height:48)
            
            Text("\(question)")
                .textStyle(.Q_Sub)
                .foregroundStyle(.black000)
                .lineLimit(2)
                .multilineTextAlignment(.center) // 글자 중앙 정렬
                .frame(width: 262)
                .padding(10)
        }
    }
}

#Preview {
    PostDetailView()
}
