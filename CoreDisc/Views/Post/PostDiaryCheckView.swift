//
//  PostDiaryCheckView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/18/25.
//

import SwiftUI

struct PostDiaryCheckView: View {
    @Environment(NavigationRouter<WriteRoute>.self) private var router
    @StateObject private var viewModel = PostDiaryViewModel()
    
    let postId: Int
    
    let selectedWho: DiaryWho
    let selectedWhere: DiaryWhere
    let selectedWhat: DiaryWhat
    let selectedMore: DiaryMore?
    let selectedMoreString: String?
    let isCore: Bool
    
    @State private var isWriteButtonTapped = false
    @State private var isShareButtonTapped = false
    
    @State private var goToWriteDiary = false
    
    @State private var isDone: Bool = false // 발행 -> 홈
    
    var body: some View {
        ZStack {
            Image(.imgDiaryCheckBg)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 87)
                
                TitleGroup
                
                Spacer().frame(height: 30)
                
                ButtonGroup
                
                DiaryGroup
            }
        }
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $isDone) {
            TabBar(startTab: .post)
        }
    }
    
    // 타이틀
    private var TitleGroup: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Today’s Core disc")
                    .textStyle(.Title_Text_Eng)
                    .foregroundStyle(.black000)
                
                Text(formattedDate)
                    .textStyle(.Sub_Text_Ko)
                    .foregroundStyle(.black000)
                    .padding(.leading, 2)
            }
            
            Spacer()
        }
        .padding(.leading, 20)
    }
    
    // 버튼
    private var ButtonGroup: some View {
        GeometryReader { g in
            HStack (spacing: 165){
                ZStack {
                    // Write버튼(수정)
                    Button(action: {
                        router.pop()
                    }) {
                        EllipticalGradient(stops: [
                            .init(color: .gray.opacity(0.0), location: 0.2692),
                            .init(color: .white, location: 0.8125)
                        ], center: .center, startRadiusFraction: 0, endRadiusFraction: 0.7431)
                        .frame(width: 152, height: 152)
                        .clipShape( Circle() )
                    }
                    
                    Image(.iconWrite)
                }
                
                // Share버튼
                ZStack {
                    Button(action: {
                        viewModel.fetchPublishPost(
                            postId: postId,
                            postData: PostPublishData(
                                publicity: isCore ? "CIRCLE" : "OFFICIAL",
                                selectiveDiary: SelectiveDiaryData(
                                    who: selectedWho.rawValue,
                                    where: selectedWhere.rawValue,
                                    what: selectedWhat.rawValue,
                                    detail: selectedMoreString
                                )
                            ))
                        isDone = true
                    }) {
                        EllipticalGradient(stops: [
                            .init(color: .gray.opacity(0.0), location: 0.2692),
                            .init(color: .white, location: 0.8125)
                        ], center: .center, startRadiusFraction: 0, endRadiusFraction: 0.7431)
                        .frame(width: 152, height: 152)
                        .clipShape( Circle() )
                    }
                    
                    Image(.iconShareWhite)
                }
            }
            .frame(width: g.size.width)
        }
        .frame(height: 152)
    }
    
    
    
    // 선택일기 요약
    private var DiaryGroup: some View {
        ZStack {
            EllipticalGradient(stops: [
                .init(color: .gray.opacity(0.0), location: 0.2692),
                .init(color: .white, location: 0.8125)],
                               center: .center,
                               startRadiusFraction: 0,
                               endRadiusFraction: 0.7431)
            
            .frame(width: 370, height: 550)
            .mask(
                VStack(spacing: 0) {
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 185,
                        bottomLeading: 0,
                        bottomTrailing: 0,
                        topTrailing: 185))
                    .frame(height: 370)
                    Rectangle()
                        .frame(height: 180)
                }
            )
            .offset(y: -20)
            
            
            VStack (alignment: .center, spacing: 13) {
                Spacer().frame(height: 41)
                
                Text("누구랑 있었나요?")
                    .textStyle(.Q_Main)
                    .foregroundStyle(.black000)
                
                Text(selectedWho.displayName)
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.black000)
                    .multilineTextAlignment(.center)
                    .frame(width: 297, height: 38)
                    .background(.gray100)
                    .clipShape( RoundedRectangle(cornerRadius: 30) )
                
                Text("어디에 있었나요?")
                    .textStyle(.Q_Main)
                    .foregroundStyle(.black000)
                
                Text(selectedWhere.displayName)
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.black000)
                    .multilineTextAlignment(.center)
                    .frame(width: 297, height: 38)
                    .background(.gray100)
                    .clipShape( RoundedRectangle(cornerRadius: 30) )
                
                Text("무엇을 했나요?")
                    .textStyle(.Q_Main)
                    .foregroundStyle(.black000)
                
                Text(selectedWhat.displayName)
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.black000)
                    .multilineTextAlignment(.center)
                    .frame(width: 297, height: 38)
                    .background(.gray100)
                    .clipShape( RoundedRectangle(cornerRadius: 30) )
                
                if selectedMore == .YES {
                    Text("더 기록하고 싶은 내용이 있나요?")
                        .textStyle(.Q_Main)
                        .foregroundStyle(.black000)
                    
                    Text(selectedMoreString!)
                        .textStyle(.Texting_Q)
                        .foregroundStyle(.black000)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 14.5)
                        .frame(width: 297, height: 83)
                        .background(.gray100)
                        .clipShape( RoundedRectangle(cornerRadius: 12) )
                }
                
                Spacer()
            }
            .padding(.bottom, 75)
        }
    }
}

// 날짜 출력
private var formattedDate: String {
    let today = Date()
    let formatter = DateFormatter()
    
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: today)
}

#Preview {
    PostDiaryCheckView(
        postId: 0,
        selectedWho: .ALONE,
        selectedWhere: .CAFE,
        selectedWhat: .EXERCISE,
        selectedMore: .YES,
        selectedMoreString: "테스트",
        isCore: false
    )
        .environment(NavigationRouter<WriteRoute>())
}
