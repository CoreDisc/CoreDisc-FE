//
//  PostWriteDiaryView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/17/25.
//

import SwiftUI

struct PostWriteDiaryView: View {
    @Environment(NavigationRouter<WriteRoute>.self) private var router
    
    @State private var selectedWho: String = "나혼자"
    @State private var selectedWhere: String = "집"
    @State private var selectedWhat: String = "공부"
    @State private var selectedMore: String = "아니요"
    
    let optionsWho = ["나혼자", "친구", "운동", "직장동료", "연인", "반려동물"]
    let optionsWhere = ["집", "학교", "회사", "야외", "카페", "이동중"]
    let optionsWhat = ["일", "공부", "운동", "휴식", "수면", "취미"]
    
    // 슬라이스 상태
    @State private var showSlices = [false, false, false, false]
    
    // 더 기록하고 싶은 내용
    @State private var moreChoice: Bool? = nil
    @State private var moreText: String = ""
    
    
    
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
                .padding(.bottom, 75)
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            for i in 0..<4 {
                let delay = 0.1 + Double(i) * 0.12
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85, blendDuration: 0.2)) {
                        showSlices[i] = true
                    }
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
            
            slice(index: 0, fromLeft: true) {
                diarySectionLeft(title: "누구와 함께했나요?", subTitle: "Who?", startColor: .orange1, endColor: .orange2, options: optionsWho, selection: $selectedWho)
            }
            
            slice(index: 1, fromLeft: false) {
                diarySectionRight(title: "어디에 있었나요?", subTitle: "Where?",startColor: .blue1, endColor: .blue2, options: optionsWhere, selection: $selectedWhere)
            }
            
            slice(index: 2, fromLeft: true) {
                diarySectionLeft(title: "무엇을 했나요??", subTitle: "What?",startColor: .purple1, endColor: .purple2, options: optionsWhat, selection: $selectedWhat)
            }
            
            slice(index: 3, fromLeft: false) {
                diarySectionMore(title: "더 기록하고 싶은 내용이 있나요??", subTitle: "More?", startColor: .pink1, endColor: .pink2, selection: $selectedMore)
            }
        }
    }
    
    
    // 선택일기 섹션(좌->우)
    private func diarySectionLeft(title: String, subTitle: String, startColor: UIColor, endColor: UIColor, options: Array<String>, selection: Binding<String>) ->
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
                .specificCornerRadius(12, corners: [.topRight, .bottomRight])
                
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
                            let isSelected = selection.wrappedValue == item
                            
                            Button (action: {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selection.wrappedValue = item
                                }
                            }){
                                Text(item)
                                    .textStyle(.Button_s)
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 57, height: 28 )
                                    .background(isSelected ? .key : Color(red: 0.949, green: 0.949, blue: 0.949))
                                    .clipShape( RoundedRectangle(cornerRadius: 30) )
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
                    .specificCornerRadius(12, corners: [.topLeft, .bottomLeft])
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
    private func diarySectionRight(title: String, subTitle: String, startColor: UIColor, endColor: UIColor, options: Array<String>, selection: Binding<String>) -> some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                Rectangle()
                    .frame(width: 105, height: 181)
                    .specificCornerRadius(12, corners: [.topRight, .bottomRight])
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
                .specificCornerRadius(12, corners: [.topLeft, .bottomLeft])
                
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
                            let isSelected = selection.wrappedValue == item
                            
                            Button (action: {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selection.wrappedValue = item
                                }
                            }){
                                Text(item)
                                    .textStyle(.Small_Text)
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 57, height: 28 )
                                    .background(isSelected ?.key : Color(red: 0.949, green: 0.949, blue: 0.949))
                                    .clipShape( RoundedRectangle(cornerRadius: 30) )
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
    
    // 선택일기 More
    private func diarySectionMore(title: String, subTitle: String, startColor: UIColor, endColor: UIColor, selection: Binding<String>) -> some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                Rectangle()
                    .frame(width: 105, height: 204)
                    .specificCornerRadius(12, corners: [.topRight, .bottomRight])
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
                
                .frame(width: 282, height: 204)
                .specificCornerRadius(12, corners: [.topLeft, .bottomLeft])
                
                VStack(alignment: .center){
                    Spacer().frame(height: 28)
                    
                    Text(title)
                        .textStyle(.Q_Main)
                        .foregroundStyle(.black)
                        //.padding(.leading, 36)
                    
                    Spacer().frame(height: 10)
                    
                    HStack(spacing: 16) {
                        let yesLabel = "네, 직접 넣을래요."
                        let noLabel  = "아니요"
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selection.wrappedValue = yesLabel
                            }
                        } label: {
                            let isSelected = (selection.wrappedValue == yesLabel)
                            Text(yesLabel)
                                .textStyle(.Small_Text)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.center)
                                .frame(width: 106, height: 28 )
                                .background(isSelected ? .key : Color(red: 0.949, green: 0.949, blue: 0.949))
                                .clipShape( RoundedRectangle(cornerRadius: 30) )
                        }
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selection.wrappedValue = noLabel
                            }
                        } label: {
                            let isSelected = (selection.wrappedValue == noLabel)
                            Text(noLabel)
                                .textStyle(.Small_Text)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.center)
                                .frame(width: 57, height: 28 )
                                .background(isSelected ? .key : Color(red: 0.949, green: 0.949, blue: 0.949))
                                .clipShape( RoundedRectangle(cornerRadius: 30) )
                        }
                    }
                    
                    Spacer().frame(height: 12)
                    
                    HStack{
                        Spacer().frame(width: 18)
                        
                        TextField("내용을 입력해 주세요", text: $moreText)
                            .foregroundStyle(.black)
                            .font(.system(size: 12))
                            .lineLimit(4)
                            .padding(.all, 10)
                            .multilineTextAlignment(.leading)
                            .frame(width: 212, height: 88, alignment: .topLeading)
                            .background(.white)
                            .clipShape( RoundedRectangle(cornerRadius: 12) )
                        
                        Spacer().frame(width: 8)
                        
                        Button(action: {
                            router.push(.summary)
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundStyle(.white)
                                
                                Image(.iconArrow)
                            }
                        }
                        
                        Spacer().frame(width: 12)
                    }
                    Spacer()
                }
            }
        }
        .frame(width: 282, height: 204)
    }

    

    @ViewBuilder
    private func slice<Content: View>(index: Int, fromLeft: Bool, @ViewBuilder content: () -> Content) -> some View {
        content()
            .opacity(showSlices[index] ? 1 : 0)
            .offset(x: showSlices[index] ? 0 : (fromLeft ? -40 : 40))
            .animation(.spring(response: 0.45, dampingFraction: 0.85), value: showSlices[index])
    }
}

#Preview {
    PostWriteDiaryView()
}
