//
//  PostWriteDiaryView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/17/25.
//

import SwiftUI

struct PostWriteDiaryView: View {
    @State private var selectedWho: String = "나혼자"
    @State private var selectedWhere: String = "집"
    @State private var selectedWhat: String = "일"
    @State private var selectedMore: String = "직접입력"
    
    let optionsWho = ["나혼자", "친구", "운동", "직장동료", "연인", "반려동물"]
    let optionsWhere = ["집", "학교", "직장", "카페"]
    let optionsWhat = ["일", "공부", "운동", "휴식", "수면", "취미생활", "여행"]
    let optionsMore = ["직접입력"]
    
    var body: some View {
        ZStack {
            Image(.imgPostDetailMainBg)
                .resizable()
                .ignoresSafeArea()
            
            ScrollView (showsIndicators: false) {
                VStack {
                    Spacer().frame(height: 25)
                    
                    TitleGroup
                    
                    Spacer().frame(height: 18)
                    
                    DiaryGroup
                }
            }
        }
    }
    
    // 타이틀
    private var TitleGroup: some View {
        VStack (alignment: .leading, spacing: 6) {
            Text("Record your Core disc")
                .textStyle(.Title_Text_Eng)
                .foregroundStyle(.black000)
            
            Text("오늘의 코어디스크를 기록해보세요.")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.black000)
        }
        .padding(.leading, 18)
        .padding(.trailing, 47)
    }
    
    // 선택일기
    private var DiaryGroup: some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer().frame(height: 12)
            
            diarySectionLeft(title: "누구와 함께했나요?", subTitle: "who?", startColor: .orange1, endColor: .orange2, options: optionsWho)
            diarySectionRight(title: "어디에 있었나요?", subTitle: "where?",startColor: .blue1, endColor: .blue2, options: optionsWhere)
            diarySectionLeft(title: "무엇을 했나요??", subTitle: "what?",startColor: .purple1, endColor: .purple2, options: optionsWhat)
            diarySectionRight(title: "더 기록하고 싶은 내용이 있나요??", subTitle: "who?", startColor: .pink1, endColor: .pink2, options: optionsMore)
        }
    }
    
    
    // 선택일기 섹션(좌->우)
    private func diarySectionLeft(title: String, subTitle: String, startColor: UIColor, endColor: UIColor, options: Array<String>) ->
    some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                EllipticalGradient(stops: [
                    .init(color: .gray.opacity(0.0), location: 0.2692),
                    .init(color: .white, location: 0.8125)],
                                   center: .center,
                                   startRadiusFraction: 0,
                                   endRadiusFraction: 0.7431)
                
                .frame(width: 282, height: 181)
                .cornerRadius(12, corners: [.topRight, .bottomRight])
                
                VStack(alignment: .leading, spacing: 10){
                    Spacer().frame(height: 18)
                    
                    Text(title)
                        .textStyle(.Q_Main)
                        .foregroundStyle(.black)
                        .padding(.leading, 36)
                    
                    LazyVGrid(columns: [
                        GridItem(.fixed(57), spacing: 20),
                        GridItem(.fixed(57), spacing: 20),
                        GridItem(.fixed(57), spacing: 20)
                    ], alignment: .leading, spacing: 8){
                        ForEach(options, id: \.self) {item in
                            Button (action: {}){
                                Text(item)
                                    .textStyle(.Small_Text)
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 57, height: 28 )
                                    .background(Color(red: 0.949, green: 0.949, blue: 0.949))
                                    .cornerRadius(30)
                            }
                        }
                    }
                    .padding(.horizontal, 36)
                    
                    Spacer()
                }
                .frame(width: 282, height: 181)
            }
            
            ZStack {
                Rectangle()
                    .frame(width: 105, height: 181)
                    .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                    .linearGradient(startColor: Color(startColor), endColor: Color(endColor))
                
                VStack {
                    Spacer()
                    
                    Text(subTitle)
                        .textStyle(.Q_Main)
                        .foregroundStyle(.white)
                        .frame(height: 43, alignment: .center)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    
    // 선택일기 (우->좌)
    private func diarySectionRight(title: String, subTitle: String, startColor: UIColor, endColor: UIColor, options: Array<String>) -> some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                Rectangle()
                    .frame(width: 105, height: 181)
                    .cornerRadius(12, corners: [.topRight, .bottomRight])
                    .linearGradient(startColor: Color(startColor), endColor: Color(endColor))
                
                VStack {
                    Spacer()
                    
                    Text(subTitle)
                        .textStyle(.Q_Main)
                        .foregroundStyle(.white)
                        .frame(height: 43, alignment: .center)
                        .multilineTextAlignment(.center)
                    
                }
            }
            
            ZStack {
                EllipticalGradient(stops: [
                    .init(color: .gray.opacity(0.0), location: 0.2692),
                    .init(color: .white, location: 0.8125)],
                                   center: .center,
                                   startRadiusFraction: 0,
                                   endRadiusFraction: 0.7431)
                
                .frame(width: 282, height: 181)
                .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                
                VStack(alignment: .leading, spacing: 10){
                    Spacer().frame(height: 18)
                    Text(title)
                        .textStyle(.Q_Main)
                        .foregroundStyle(.black)
                        .padding(.leading, 36)
                    
                    LazyVGrid(columns: [
                        GridItem(.fixed(57), spacing: 20),
                        GridItem(.fixed(57), spacing: 20),
                        GridItem(.fixed(57), spacing: 20)
                    ], alignment: .leading, spacing: 8){
                        ForEach(options, id: \.self) {item in
                            Button (action: {}){
                                Text(item)
                                    .textStyle(.Small_Text)
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 57, height: 28 )
                                    .background(Color(red: 0.949, green: 0.949, blue: 0.949))
                                    .cornerRadius(30)
                            }
                        }
                    }
                    .padding(.horizontal, 36)
                    
                    Spacer()
                }
                .frame(width: 282, height: 181)
            }
        }
    }
}

#Preview {
    PostWriteDiaryView()
}
