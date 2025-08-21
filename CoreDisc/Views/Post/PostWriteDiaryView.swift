//
//  PostWriteDiaryView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/17/25.
//

import SwiftUI

struct PostWriteDiaryView: View {
    @Environment(NavigationRouter<WriteRoute>.self) private var router
    
    let postId: Int
    
    @State private var selectedWho: DiaryWho = .ALONE
    @State private var selectedWhere: DiaryWhere = .HOME
    @State private var selectedWhat: DiaryWhat = .WORK
    @State private var selectedMore: DiaryMore = .YES
    let isCore: Bool
    
    let optionsWho: [DiaryWho] = DiaryWho.allCases.filter { $0 != .UNKNOWN }
    let optionsWhere: [DiaryWhere] = DiaryWhere.allCases.filter { $0 != .UNKNOWN }
    let optionsWhat: [DiaryWhat] = DiaryWhat.allCases.filter { $0 != .UNKNOWN }
    
    // 슬라이스 상태
    @State private var showSlices = [false, false, false, false]
    
    // 더 기록하고 싶은 내용
    @State private var moreChoice: Bool? = nil
    @State private var moreText: String = ""
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Image(.imgPostDetailMainBg)
                .resizable()
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Spacer().frame(height: 31)
                    
                    TitleGroup
                    
                    Spacer().frame(height: 18)
                    
                    DiaryGroup
                        .onTapGesture { // 키보드 내리기 용도
                            isFocused = false
                        }
                }
                .padding(.bottom, 75)
            }
            .scrollIndicators(.hidden)
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
        HStack {
            VStack (alignment: .leading, spacing: 6) {
                Text("Record your Core disc")
                    .textStyle(.Title_Text_Eng)
                    .foregroundStyle(.black000)
                
                Text("오늘의 코어디스크를 기록해보세요.")
                    .textStyle(.Sub_Text_Ko)
                    .foregroundStyle(.black000)
            }
            
            Spacer()
        }
        .padding(.leading, 18)
    }
    
    // 선택일기
    private var DiaryGroup: some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer().frame(height: 12)
            
            slice(index: 0, fromLeft: true) {
                diarySectionLeft(title: "누구와 함께했나요?", subTitle: "Who?", startColor: .yellow1, endColor: .yellow2, options: optionsWho, selection: $selectedWho)
            }
            
            slice(index: 1, fromLeft: false) {
                diarySectionRight(title: "어디에 있었나요?", subTitle: "Where?",startColor: .blue1, endColor: .blue2, options: optionsWhere, selection: $selectedWhere)
            }
            
            slice(index: 2, fromLeft: true) {
                diarySectionLeft(title: "무엇을 했나요?", subTitle: "What?",startColor: .purple1, endColor: .purple2, options: optionsWhat, selection: $selectedWhat)
            }
            
            slice(index: 3, fromLeft: false) {
                diarySectionMore(title: "더 기록하고 싶은 내용이 있나요?", subTitle: "More?", startColor: .pink1, endColor: .pink2, selection: $selectedMore)
            }
        }
    }
    
    
    // 선택일기 섹션(좌->우)
    private func diarySectionLeft<T: DiaryDisplayable & Hashable>(
        title: String,
        subTitle: String,
        startColor: UIColor,
        endColor: UIColor,
        options: [T],
        selection: Binding<T>
    ) -> some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                EllipticalGradient(stops: [
                    .init(color: .gray.opacity(0.0), location: 0.2692),
                    .init(color: .white, location: 0.8125)],
                                   center: .center,
                                   startRadiusFraction: 0,
                                   endRadiusFraction: 0.7431)
                
                .frame(width: 282, height: 181)
                .specificCornerRadius(12, corners: [.topRight])
                
                VStack(alignment: .leading, spacing: 10) {
                    Spacer().frame(height: 28)
                    
                    Text(title)
                        .textStyle(.Q_Main)
                        .foregroundStyle(.black000)
                        .padding(.leading, 36)
                    
                    LazyVGrid(columns: [
                        GridItem(.fixed(57), spacing: 20),
                        GridItem(.fixed(57), spacing: 20),
                        GridItem(.fixed(57), spacing: 20)
                    ], alignment: .leading, spacing: 8){
                        ForEach(options, id: \.self) { item in
                            let isSelected = selection.wrappedValue == item
                            
                            Button (action: {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selection.wrappedValue = item
                                }
                            }){
                                Text(item.displayName)
                                    .textStyle(.Button_s)
                                    .foregroundStyle(.black000)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 57, height: 28 )
                                    .background(isSelected ? .key : .gray100)
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
                    .specificCornerRadius(12, corners: [.topLeft])
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
    private func diarySectionRight<T: DiaryDisplayable & Hashable>(
        title: String,
        subTitle: String,
        startColor: UIColor,
        endColor: UIColor,
        options: [T],
        selection: Binding<T>
    ) -> some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                Rectangle()
                    .frame(width: 105, height: 181)
                    .specificCornerRadius(12, corners: [.topRight])
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
                .specificCornerRadius(12, corners: [.topLeft])
                
                VStack(alignment: .leading, spacing: 10) {
                    Spacer().frame(height: 28)
                    Text(title)
                        .textStyle(.Q_Main)
                        .foregroundStyle(.black000)
                        .padding(.leading, 36)
                    
                    LazyVGrid(columns: [
                        GridItem(.fixed(57), spacing: 20),
                        GridItem(.fixed(57), spacing: 20),
                        GridItem(.fixed(57), spacing: 20)
                    ], alignment: .leading, spacing: 8){
                        ForEach(options, id: \.self) { item in
                            let isSelected = selection.wrappedValue == item
                            
                            Button (action: {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selection.wrappedValue = item
                                }
                            }){
                                Text(item.displayName)
                                    .textStyle(.Q_pick)
                                    .foregroundStyle(.black000)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 57, height: 28 )
                                    .background(isSelected ? .key : .gray100)
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
    private func diarySectionMore(
        title: String,
        subTitle: String,
        startColor: UIColor,
        endColor: UIColor,
        selection: Binding<DiaryMore>
    ) -> some View {
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
                        .foregroundStyle(.black000)
                    
                    Spacer().frame(height: 10)
                    
                    HStack(spacing: 16) {
                        ForEach(DiaryMore.allCases) { item in
                            let isSelected = (selection.wrappedValue == item)
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selection.wrappedValue = item
                                }
                            }) {
                                Text(item.displayName)
                                    .textStyle(.Q_pick)
                                    .foregroundStyle(.black000)
                                    .multilineTextAlignment(.center)
                                    .frame(width: item == .YES ? 115 : 57, height: 28)
                                    .background(isSelected ? .key : .gray100)
                                    .clipShape( RoundedRectangle(cornerRadius: 30) )
                            }
                        }
                    }
                    
                    HStack{
                        Spacer().frame(width: 18)
                        
                        TextField("내용을 입력해 주세요", text: $moreText)
                            .focused($isFocused)
                            .foregroundStyle(.black000)
                            .textStyle(.A_Main)
                            .lineLimit(4)
                            .padding(10)
                            .multilineTextAlignment(.leading)
                            .frame(width: 212, height: 88, alignment: .topLeading)
                            .background(selection.wrappedValue == .NO ? .gray200 : .white)
                            .disabled(selection.wrappedValue == .NO)
                            .clipShape( RoundedRectangle(cornerRadius: 12) )
                        
                        Spacer().frame(width: 8)
                        
                        Button(action: {
                            router.push(.summary(
                                postId: postId,
                                selectedWho: selectedWho,
                                selectedWhere: selectedWhere,
                                selectedWhat: selectedWhat,
                                selectedMore: selectedMore,
                                selectedString: moreText,
                                isCore: isCore
                            ))
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
    PostWriteDiaryView(postId: 0, isCore: false)
        .environment(NavigationRouter<WriteRoute>())
}
