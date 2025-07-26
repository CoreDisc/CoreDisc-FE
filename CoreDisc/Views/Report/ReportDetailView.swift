//
//  ReportDetailView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/19/25.
//

import SwiftUI

struct ReportDetailView: View {
    
    var body: some View {
        ZStack{
            Image(.imgLongBackground)
                .resizable()
                .ignoresSafeArea()
            VStack{
                ScrollView(.vertical){
                    LazyVStack{
                        HeaderGroup
                        TotalDiscGroup
                        Spacer().frame(height: 64)
                        RandomGroup
                        Spacer().frame(height: 64)
                        TimeReportGroup
                        Spacer().frame(height: 44)
                        GoSummaryGroup
                    }
                    .padding(.bottom, 107)
                }
                
                PresentGroup

            }
        }
    }
    
    private var HeaderGroup : some View{
        HStack{
            Image(.imgReportHeaderIcon)
            Spacer()
            Image(.imgGoback)
                .padding(.trailing, 14)
        }
    }
    
    private var TotalDiscGroup : some View{
        VStack(alignment: .leading){
            Text("5월에는 총")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.bottom, 2)
                .padding(.leading, 35)
            Text("22개의 DISC를 작성했어요")
                .textStyle(.Title2_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 35)
            
            ZStack{
                Image(.imgReportCd)
                    .resizable()
                    .frame(width: 400, height: 400)
                    .offset(x: -220)
                
                //글자 제한 수정 필요
                ReportFirstQuestion(image: Image(.iconYellow), question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.")
                    .position(x: 213, y: 55)
                
                ReportFirstQuestion(image: Image(.iconMint), question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.")
                    .position(x: 248, y: 100)
                
                ReportFirstQuestion(image: Image(.iconMint), question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.")
                    .position(x: 271, y: 165)
                
                ReportFirstQuestion(image: Image(.iconPurple), question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.")
                    .position(x: 271, y: 235)
                
                ReportFirstQuestion(image: Image(.iconPurple), question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.")
                    .position(x: 248, y: 300)

                ReportFirstQuestion(image: Image(.iconPink), question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.")
                    .position(x: 213, y: 345)
            }
        }
    }
    
    private var RandomGroup : some View{
        VStack(alignment: .trailing){
            Text("5월에")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.bottom, 2)
                .padding(.trailing, 36)
            Text("가장 많이 선택한 랜덤 질문은")
                .textStyle(.Title2_Text_Ko)
                .foregroundStyle(.white)
                .padding(.trailing, 36)
            
            ScrollView(.horizontal){
                LazyHStack{
                    Rectangle()
                        .fill(Color.gray400)
                        .frame(width: 180, height: 180)
                        .cornerRadius(12)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 200, height: 200)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(.highlight), Color(.gray600)]),
                                startPoint: UnitPoint(x: 0.8, y: 0.3), endPoint: UnitPoint(x: 0.2, y: 1.4)
                            )
                        )
                        .cornerRadius(12)
                    Rectangle()
                        .fill(Color.gray400)
                        .frame(width: 180, height: 180)
                        .cornerRadius(12)
                    
                }
            }
        }
    }
    
    private var TimeReportGroup : some View{
        VStack(alignment: .leading){
            Text("5월의 DISC는")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.bottom, 2)
            Text("이 시간대에 가장 많이 기록되었어요")
                .textStyle(.Title2_Text_Ko)
                .foregroundStyle(.white)
            
            Spacer().frame(height: 19)
            Image(.iconTimePink)
        }
    }
    
    private var GoSummaryGroup : some View{
        VStack{
            Button(action:{}, label:{
                ZStack{
                    Rectangle()
                        .cornerRadius(16)
                        .foregroundStyle(.white)
                    HStack{
                        VStack(alignment: .leading){
                            Text("DISC Summary")
                                .textStyle(.Pick_Q_Eng)
                                .foregroundStyle(.black000)
                            Text("선택형 일기 리포트 보기")
                                .textStyle(.Q_Main)
                                .foregroundStyle(.black000)
                        }
                        Spacer()
                        Image(.iconGo)
                    }
                    .padding(18)
                }
            })
            
            Spacer().frame(height: 19)
            ZStack{
                Image(.imgSpeechbubble)
                Text("5월은 누구와 가장 많이 함께했을까요?")
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.black000)
                    .padding(.top, 10)
            }
        }
        .padding(.horizontal, 41)
    }
    
    private var PresentGroup : some View{
        ZStack{
            Rectangle()
                .frame(height: 107)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.25), radius: 4.2, x: 0, y: 1)
            HStack{
                Image(.imgProfile)
                    .cornerRadius(100)
                Spacer().frame(width: 21)
                VStack(alignment: .leading){
                    Text("2025 - 07")
                        .textStyle(.Button)
                        .foregroundStyle(.black)
                    Text("뮤직사마")
                        .textStyle(.Button)
                        .foregroundStyle(.black)
                }
                Spacer()
                HStack{
                    Button(action:{}, label:{
                        Image(.iconBefore)
                    })
                    Spacer().frame(width: 19)
                    Button(action:{}, label:{
                        Image(.iconPlay)
                    })
                    Spacer().frame(width: 19)
                    Button(action:{}, label:{
                        Image(.iconNext)
                    })
                }
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 40)
    }
}
    
struct ReportFirstQuestion: View {
    
    let image : Image
    let question : String
    
    var body: some View {
        HStack{
            image
                .padding(.trailing, 4)
            Text(question)
                .textStyle(.Small_Text_10)
                .foregroundStyle(.white)
                .frame(maxWidth:176)
        }
    }
}


#Preview {
    ReportDetailView()
}
