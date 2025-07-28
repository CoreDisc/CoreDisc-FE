//
//  ReportSummaryView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/26/25.
//

import SwiftUI

struct ReportSummaryView: View {
    @State private var currentIndex: Int = 0
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
                        Spacer().frame(height: 60)
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
            
            ForEach(viewModel.SummaryQuest, id: \.question){ item in
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
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        ForEach(viewModel.ExtraDisc.indices, id: \.self) { index in
                            let isCurrent = index == currentIndex
                            let isNextOrPrevious = abs(index - currentIndex) == 1
                            
                            if isCurrent || isNextOrPrevious {
                                VStack(spacing: 8) {
                                    HStack{
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(isCurrent ? Color.black000 : Color.gray800)
                                                .frame(width: isCurrent ? 288 : 268,
                                                       height: isCurrent ? 108 : 100)
                                            Text(viewModel.ExtraDisc[index].text)
                                                .foregroundColor(.white)
                                                .textStyle(isCurrent ? .Bold_Text : .Button_s)
                                                .multilineTextAlignment(.center)
                                                .padding()
                                                .frame(width: isCurrent ? 288 : 268)
                                                .lineLimit(3)
                                        }
                                        Text(viewModel.ExtraDisc[index].date)
                                            .textStyle(isCurrent ? .Button : .Button_s)
                                            .foregroundColor(.gray200)
                                            .offset(y:38)
                                    }
                                }
                                .scaleEffect(isCurrent ? 1 : 0.85)
                                .opacity(isCurrent ? 1 : 0.5)
                                .animation(.easeInOut(duration: 0.3), value: currentIndex)
                            } else {
                                EmptyView()
                            }
                        }
                    }
                    Spacer()
                }
                .frame(height: 345)
                .clipped()
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.height < -50 && currentIndex < viewModel.ExtraDisc.count - 1 {
                                currentIndex += 1
                            } else if value.translation.height > 50 && currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }
                )
            }
            .frame(height: 345)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 26)
    }
}

#Preview {
    ReportSummaryView()
}
