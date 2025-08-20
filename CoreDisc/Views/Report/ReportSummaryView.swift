//
//  ReportSummaryView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/26/25.
//

import SwiftUI
import Kingfisher

struct ReportSummaryView: View {
    @Environment(NavigationRouter<ReportRoute>.self) private var router
    
    @State private var currentIndex: Int = 0
    @StateObject private var viewModel = ReportSummaryViewModel()
    @StateObject private var myHomeViewModel = MyHomeViewModel()
    
    let SummaryYear: Int
    let SummaryMonth: Int
    
    var beforeDiscMonth: Int {
        (SummaryMonth == 12) ? 1 : SummaryMonth + 1
    }
    
    var beforeDiscYear: Int {
        (SummaryMonth == 1) ? SummaryYear + 1 : SummaryYear
    }
    
    var nextDiscMonth: Int {
        (SummaryMonth == 1) ? 12 : SummaryMonth - 1
    }
    
    var nextDiscYear: Int {
        (SummaryMonth == 12) ? SummaryYear - 1 : SummaryYear
    }
    
    
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
        .navigationBarBackButtonHidden()
        .task {
            viewModel.getSummaryTop(year: SummaryYear, month: SummaryMonth)
            viewModel.getSummaryDetails(year: SummaryYear, month: SummaryMonth)
            myHomeViewModel.fetchMyHome()
        }
        .tabBarHidden(true) // 커스텀 탭바 숨기기
    }
    
    private var HeaderGroup : some View{
        ZStack{
            HStack{
                Spacer()
                Image(.imgLogoOneline)
                Spacer()
            }
            HStack{
                Image(.imgReportHeaderIcon)
                Button(action: {
                    router.pop()
                }){
                    Image(.imgGoback)
                }
                Spacer()
            }
        }
    }
    
    private var SummaryGroup : some View{
        VStack(alignment: .leading){
            Text("Summary")
                .textStyle(.Pick_Q_Eng)
                .foregroundStyle(.white)
                .padding(.bottom, 2)
                .padding(.leading, 35)
            Text("\(SummaryMonth)월의 CORE DISC")
                .textStyle(.Title2_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 35)
            
            ForEach(viewModel.summaryTop, id: \.dailyType){ item in
                ZStack{
                    SummaryQuest(question: item.dailyType, answer: item.optionContent, freq: item.selectionCount)
                        .padding(.vertical, 10)
                }
            }
        }
    }
    
    private var PresentGroup : some View{
        ZStack{
            Rectangle()
                .frame(height: 107)
                .specificCornerRadius(24, corners: [.topLeft, .topRight])
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.25), radius: 4.2, x: 0, y: 1)
            HStack{
                if let url = URL(string: myHomeViewModel.profileImageURL) {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }
                Spacer().frame(width: 21)
                VStack(alignment: .leading){
                    Text("\(String(SummaryYear)) - \(String(format: "%02d", SummaryMonth))")
                        .textStyle(.Button)
                        .foregroundStyle(.black)
                    Text(myHomeViewModel.nickname)
                        .textStyle(.Button)
                        .foregroundStyle(.black)
                }
                Spacer()
                HStack {
                    NavigationLink(destination: ReportDetailView(year: beforeDiscYear, month: beforeDiscMonth)){
                        Image(.iconBefore)
                    }
                    Spacer().frame(width: 19)
                    
                    Image(.iconPlay)
                    Spacer().frame(width: 19)
                    
                    NavigationLink(destination: ReportDetailView(year: nextDiscYear, month: nextDiscMonth)){
                        Image(.iconNext)
                    }
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 26)
    }
}

#Preview {
    ReportSummaryView(SummaryYear: 2025, SummaryMonth: 7)
}
