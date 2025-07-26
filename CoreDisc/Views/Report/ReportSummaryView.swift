//
//  ReportSummaryView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/26/25.
//

import SwiftUI

struct ReportSummaryView: View {
    
    let viewModel = ReportSummaryViewModel()
    
    var body: some View {
        ZStack{
            Image(.imgLongBackground)
                .resizable()
                .ignoresSafeArea()
            VStack{
                ScrollView(.vertical){
                    LazyVStack{
                        HeaderGroup
                        SummaryGroup
                        ExtraDiscGroup
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
    
    private var SummaryGroup : some View{
        VStack(alignment: .leading){
            Text("Summary")
                .textStyle(.Pick_Q_Eng)
                .foregroundStyle(.white)
                .padding(.bottom, 2)
                .padding(.leading, 35)
            Text("5월의 CORE DISC")
                .textStyle(.Title2_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 35)
            
            ForEach(viewModel.SummaryQuest, id: \.id){ item in
                ZStack{
                    SummaryQuest(question: item.question, answer: item.answer, freq: item.freq)
                        .padding(.vertical, 10)
                }
            }
        }
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
    
    private var ExtraDiscGroup : some View{
        VStack(alignment: .leading){
            Text("추가로 기록했던 DISC를 살펴봐요")
                .textStyle(.Title2_Text_Ko)
                .foregroundStyle(.white)
            HStack{
                Capsule().frame(width: 2, height: 345)
                    .foregroundStyle(.highlight)
                    .padding(.trailing, 13)
                VStack{
                    HStack{
                        ZStack{
                            Rectangle()
                                .cornerRadius(10.5)
                                .frame(width:271, height: 108)
                                .foregroundStyle(.black000)
                            Text("7월은 집에서 가장 많은 시간을 보냈네요. 정말 덥고 습하고 절대 밖으로 나가지 않았네요 에어컨이 없으면  살 수가 없을 지경입니다 아이스크림을 하루에 3개씩 먹고 있어요")
                                .textStyle(TextStyle(
                                    font: .pretendard(type: .bold, size: 14),
                                    kerning: -0.7,
                                    lineSpacing: 8
                                ))
                                .foregroundStyle(.white)
                                .frame(width:244)
                        }
                            Text("7/1")
                                .textStyle(.Button)
                                .foregroundStyle(.gray200)
                                .offset(y: 40)
                    }
                }
            }
        }
    }
    
}

#Preview {
    ReportSummaryView()
}
