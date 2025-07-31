//
//  PostDiaryCheckView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/18/25.
//

import SwiftUI

struct PostDiaryCheckView: View {
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
    // TODO: 버튼 애니메이션 추가 예정
    private var ButtonGroup: some View {
        VStack {
            HStack (spacing: 165){
                ZStack {
                    Button(action: {}) {
                        EllipticalGradient(stops: [
                            .init(color: .gray.opacity(0.0), location: 0.2692),
                            .init(color: .white, location: 0.8125)],
                                           center: .center,
                                           startRadiusFraction: 0,
                                           endRadiusFraction: 0.7431)
                        
                        .frame(width: 152, height: 152)
                        .cornerRadius(152)
                    }
                    Image(.iconWrite)
                }
                
                ZStack {
                    Button(action: {}) {
                        EllipticalGradient(stops: [
                            .init(color: .gray.opacity(0.0), location: 0.2692),
                            .init(color: .white, location: 0.8125)],
                                           center: .center,
                                           startRadiusFraction: 0,
                                           endRadiusFraction: 0.7431)
                        
                        .frame(width: 152, height: 152)
                        .cornerRadius(152)
                    }
                    Image(.iconShare)
                }
            }
        }
    }
    
    
    // 선택일기 요약
    private var DiaryGroup: some View {
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
        .offset(y: -40)
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
