//
//  PostDiaryCheckView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/18/25.
//

import SwiftUI

struct PostDiaryCheckView: View {
    @Environment(NavigationRouter<WriteRoute>.self) private var router
    
    @State private var isWriteButtonTapped = false
    @State private var isShareButtonTapped = false
    
    @State private var goToWriteDiary = false
    
    @State private var isDone: Bool = false // 발행 -> 홈
    
    var body: some View {
        ZStack {
            Image(.imgDiaryCheckBg)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 65)
                
                TitleGroup
                
                Spacer().frame(height: 56)
                
                ButtonGroup
                
                DiaryGroup
            }
        }
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $isDone) {
            TabBar(startTab: .home)
        }
    }
    
    // 타이틀
    private var TitleGroup: some View {
        VStack (alignment: .leading, spacing: 6) {
            Text("Today’s Core disc")
                .textStyle(.Title_Text_Eng)
                .foregroundStyle(.black000)
            
            Text(formattedDate)
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.black000)
                .padding(.leading, 2)
        }
        .padding(.leading, 18)
        .padding(.trailing, 110)
    }
    
    // 버튼
    // TODO: 버튼 화면 연결
    private var ButtonGroup: some View {
        VStack {
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
                        .scaleEffect(isWriteButtonTapped ? 1.2 : 1.0)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        withAnimation(.easeInOut(duration: 0.2)) { isWriteButtonTapped = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeInOut(duration: 0.2)) { isWriteButtonTapped = false }
                        }
                    })
                    
                    Image(.iconWrite)
                }
                
                // Share버튼
                ZStack {
                    Button(action: {
                        isDone = true
                    }) {
                        EllipticalGradient(stops: [
                            .init(color: .gray.opacity(0.0), location: 0.2692),
                            .init(color: .white, location: 0.8125)
                        ], center: .center, startRadiusFraction: 0, endRadiusFraction: 0.7431)
                        .frame(width: 152, height: 152)
                        .clipShape( Circle() )
                        .scaleEffect(isShareButtonTapped ? 1.2 : 1.0)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        withAnimation(.easeInOut(duration: 0.2)) { isShareButtonTapped = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeInOut(duration: 0.2)) { isShareButtonTapped = false }
                        }
                    })
                    
                    Image(.iconShareWhite)
                }
            }
        }
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
                Spacer().frame(height: 28)
                
                Text("누구랑 있었나요?")
                    .textStyle(.Q_Main)
                    .foregroundStyle(.black000)
                
                Text("가족")
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.black000)
                    .multilineTextAlignment(.center)
                    .frame(width: 297, height: 38)
                    .background(.gray100)
                    .clipShape( RoundedRectangle(cornerRadius: 30) )
                
                Text("어디에 있었나요??")
                    .textStyle(.Q_Main)
                    .foregroundStyle(.black000)
                
                Text("집")
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.black000)
                    .multilineTextAlignment(.center)
                    .frame(width: 297, height: 38)
                    .background(.gray100)
                    .clipShape( RoundedRectangle(cornerRadius: 30) )
                
                Text("무엇을 했나요?")
                    .textStyle(.Q_Main)
                    .foregroundStyle(.black000)
                
                Text("요리")
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.black000)
                    .multilineTextAlignment(.center)
                    .frame(width: 297, height: 38)
                    .background(.gray100)
                    .clipShape( RoundedRectangle(cornerRadius: 30) )
                
                Text("더 기록하고 싶은 내용이 있나요?")
                    .textStyle(.Q_Main)
                    .foregroundStyle(.black000)
                
                Text("오늘 오랜만에 친구랑 저녁 먹었는데 진짜 별 얘기 안 했는데도 너무 편하고 좋았어. 같이 웃고, 먹고, 걷고 그런 게 뭐 대단한 건 아닌데 괜히 마음이 따뜻해지더라.")
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.black000)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 14.5)
                    .frame(width: 297, height: 83)
                    .background(.gray100)
                    .clipShape( RoundedRectangle(cornerRadius: 12) )
                
                Spacer()
            }
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
    PostDiaryCheckView()
}
