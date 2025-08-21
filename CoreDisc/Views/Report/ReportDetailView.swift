//
//  ReportDetailView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/19/25.
//

import SwiftUI
import Kingfisher

struct ReportDetailView: View {
    @Environment(NavigationRouter<ReportRoute>.self) private var router
    
    @State private var nowIndex: Int = 1
    @StateObject private var myHomeViewModel = MyHomeViewModel()
    @StateObject private var viewModel: ReportDetailViewModel
    @StateObject private var DiscQuestionViewModel: DiscViewModel
    
    init(year: Int, month: Int) {
        let reportVM = ReportDetailViewModel()
        _viewModel = StateObject(wrappedValue: reportVM)
        _DiscQuestionViewModel = StateObject(wrappedValue: DiscViewModel(reportVM: reportVM))
        self.year = year
        self.month = month
    }
    
    @State private var rotate = false
    @State private var questionsOpacity: Double = 1.0
    
    let year: Int
    let month: Int
    
    var beforeDiscMonth: Int {
        (month == 12) ? 1 : month + 1
    }
    
    var beforeDiscYear: Int {
        (month == 12) ? year + 1 : year
    }
    
    var nextDiscMonth: Int {
        (month == 1) ? 12 : month - 1
    }
    
    var nextDiscYear: Int {
        (month == 1) ? year - 1 : year
    }
    
    let sixItemPositions: [CGPoint] = [
        CGPoint(x: 213, y: 55),
        CGPoint(x: 250, y: 103),
        CGPoint(x: 271, y: 165),
        CGPoint(x: 271, y: 235),
        CGPoint(x: 250, y: 297),
        CGPoint(x: 213, y: 345)
    ]
    
    let fourItemPositions: [CGPoint] = [
        CGPoint(x: 250, y: 103),
        CGPoint(x: 271, y: 165),
        CGPoint(x: 271, y: 235),
        CGPoint(x: 250, y: 297)
    ]
    
    
    var body: some View {
        ZStack {
            Image(.imgLongBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                ScrollView(.vertical) {
                    LazyVStack {
                        HeaderGroup
                        TotalDiscGroup
                            .highPriorityGesture(
                                DragGesture(minimumDistance: 5)
                                    .onEnded { value in
                                        if value.translation.height < -5 {
                                            if DiscQuestionViewModel.hasNextPage {
                                                animatePageChange {
                                                    DiscQuestionViewModel.nextPage()
                                                }
                                            } else {
                                                DiscQuestionViewModel.nextPage()
                                            }
                                        } else if value.translation.height > 5 {
                                            if DiscQuestionViewModel.hasPreviousPage {
                                                animatePageChange {
                                                    DiscQuestionViewModel.previousPage()
                                                }
                                            } else {
                                                DiscQuestionViewModel.previousPage()
                                            }
                                        }
                                    }
                            )
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
            .task {
                viewModel.getReport(year: year, month: month)
                myHomeViewModel.fetchMyHome()
            }
        }
        .navigationBarBackButtonHidden()
        .tabBarHidden(true) // 커스텀 탭바 숨기기
    }
    
    //디스크 애니메이션
    private func animatePageChange(completion: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: 0.15)) {
            questionsOpacity = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            completion()
            
            withAnimation(.easeInOut(duration: 0.15)) {
                questionsOpacity = 1.0
            }
        }
    }
    
    private var HeaderGroup: some View {
        ZStack{
            HStack{
                Spacer()
                Image(.imgLogoOneline)
                Spacer()
            }
            HStack {
                Image(.imgReportHeaderIcon)
                
                Button(action: {
                    router.reset()
                }){
                    Image(.imgGoback)
                }
                Spacer()
            }
        }
    }
    
    private var TotalDiscGroup: some View {
        VStack(alignment: .leading) {
            Text("\(month)월에는 총")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.bottom, 2)
                .padding(.leading, 35)
            
            Text("\(viewModel.DiscCount)개의 DISC를 작성했어요")
                .textStyle(.Title2_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 35)
            
            ZStack {
                Image(.imgReportCd)
                    .resizable()
                    .frame(width: 400, height: 400)
                    .rotationEffect(.degrees(rotate ? 360 : 0))
                    .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false), value: rotate)
                    .offset(x: -220)
                    .task {
                        rotate = true
                    }
                
                ForEach(Array(DiscQuestionViewModel.pagedItems.enumerated()), id: \.offset) { index, item in
                    let positions = DiscQuestionViewModel.pagedItems.count == 4 ? fourItemPositions : sixItemPositions
                    if index < positions.count {
                        DiscQuestion(item: item, position: positions[index])
                            .opacity(questionsOpacity)
                            .animation(.easeInOut(duration: 0.25), value: questionsOpacity)
                            .transition(.opacity)
                    }
                }
            }
            
        }
    }
    
    private var RandomGroup: some View {
        VStack(alignment: .trailing) {
            Text("\(month)월에")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.bottom, 2)
                .padding(.trailing, 36)
            
            Text("가장 많이 선택한 하루질문은")
                .textStyle(.Title2_Text_Ko)
                .foregroundStyle(.white)
                .padding(.trailing, 36)
            
            HStack(spacing: 16) {
                ForEach(viewModel.MostQuestionItem.indices, id: \.self) { index in
                    let isCurrent = index == nowIndex
                    let isNextOrPrevious = abs(index - nowIndex) == 1
                    
                    if isCurrent || isNextOrPrevious {
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: 200, height: 200)
                                .background(
                                    Group {
                                        if isCurrent {
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(.highlight), Color(.gray600)]),
                                                startPoint: UnitPoint(x: 0.8, y: 0.3),
                                                endPoint: UnitPoint(x: 0.2, y: 1.4)
                                            )
                                        } else {
                                            Color(.gray400)
                                        }
                                    }
                                )
                                .clipShape( RoundedRectangle(cornerRadius: 12) )
                            
                            VStack{
                                if !viewModel.MostQuestionItem[index].questionContent.isEmpty {
                                    VStack {
                                        Text(viewModel.MostQuestionItem[index].questionContent)
                                            .foregroundColor(.black000)
                                            .multilineTextAlignment(.center) .textStyle(.Texting_Q)
                                            .padding()
                                        if let count = viewModel.MostQuestionItem[index].selectedCount {
                                            Text("총 \(count)회")
                                                .textStyle(.Title2_Text_Ko)
                                                .foregroundColor(.black000)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                                .offset(y:30)
                                                .padding()
                                        }
                                    }
                                }
                            }
                        }
                        .scaleEffect(isCurrent ? 1.0 : 0.85)
                        .opacity(isCurrent ? 1 : 0.5)
                        .animation(.easeInOut(duration: 0.3), value: nowIndex)
                    } else {
                        EmptyView()
                    }
                }
            }
            .frame(height: 200)
            .clipped()
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > 50 && nowIndex > 0 {
                            if nowIndex == 1 {
                                return
                            }
                            nowIndex -= 1
                        }
                        else if value.translation.width < -50 && nowIndex < viewModel.MostQuestionItem.count - 1 {
                            if nowIndex == viewModel.MostQuestionItem.count - 2 {
                                return
                            }
                            nowIndex += 1
                        }
                    }
            )
            .frame(width: UIScreen.main.bounds.width)
        }
    }
    
    private var TimeReportGroup: some View {
        VStack(alignment: .leading) {
            Text("\(month)월의 DISC는")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.bottom, 2)
            
            Text("이 시간대에 가장 많이 기록되었어요")
                .textStyle(.Title2_Text_Ko)
                .foregroundStyle(.white)
            
            Spacer().frame(height: 19)
            Image(viewModel.PeakTimeImage)
        }
    }
    
    private var GoSummaryGroup: some View {
        VStack {
            Button(action: {
                router.push(.summary(SummaryYear: year, SummaryMonth: month))
            }){
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.white)
                    
                    HStack {
                        VStack(alignment: .leading) {
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
            }
            
            Spacer().frame(height: 19)
            
            ZStack {
                Image(.imgSpeechbubble)
                
                Text("\(month)월은 누구와 가장 많이 함께했을까요?")
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.black000)
                    .padding(.top, 10)
            }
        }
        .padding(.horizontal, 41)
    }
    
    private var PresentGroup: some View {
        ZStack {
            Rectangle()
                .frame(height: 107)
                .specificCornerRadius(24, corners: [.topLeft, .topRight])
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.25), radius: 4.2, x: 0, y: 1)
            
            HStack {
                if let url = URL(string: myHomeViewModel.profileImageURL) {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }
                
                Spacer().frame(width: 21)
                
                VStack(alignment: .leading) {
                    Text("\(String(year)) - \(String(format: "%02d", month))")
                        .textStyle(.Button)
                        .foregroundStyle(.black)
                    
                    Text(myHomeViewModel.nickname)
                        .textStyle(.Button)
                        .foregroundStyle(.black)
                        .lineLimit(1)
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        if viewModel.hasNextReport{
                            router.push(.detail(year: beforeDiscYear, month: beforeDiscMonth))
                        }
                    }, label: {
                        Image(.iconBefore)
                    })
                    Spacer().frame(width: 19)
                    
                    
                    Image(.iconPlay)
                    Spacer().frame(width: 19)
                    
                    Button(action: {
                        if viewModel.hasPreviousReport{
                            router.push(.detail(year: nextDiscYear, month: nextDiscMonth))
                        }
                    }, label: {
                        Image(.iconNext)
                    })
                }
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 40)
    }
}

#Preview {
    ReportDetailView(year: 2025, month: 7)
}
