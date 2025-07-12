//
//  QuestionWriteView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct QuestionWriteView: View {
    let bubbleGradient = EllipticalGradient(
        stops: [
            .init(color: .grayText.opacity(0.0), location: 0.2692),
            .init(color: .white, location: 0.8125)
        ],
        center: .center,
        startRadiusFraction: 0,
        endRadiusFraction: 0.7431
    )
    
    @State var selectedCategory: String? = nil
    @State var text: String
    @State var isDone: Bool = false
    
    
    var body: some View {
        ScrollView {
            ZStack {
                
                VStack {
                    WriteSuggestion
                    Spacer().frame(height: 43)
                    QuestionCategory
                    Spacer().frame(height: 43)
                    QuestionInput
                    Spacer().frame(height: 15)
                    QuestionCaution
                    Spacer().frame(height: 43)
                    PrimaryActionButton(title:"확인 및 저장", isFinished: .constant(!text.isEmpty && selectedCategory != nil))
                }
            }
        }
        .background(
            Image(.imgLongBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
    
    
    // 상단 타이틀
    var WriteSuggestion: some View {
            VStack{
                HStack {
                    Button(action: {}){
                        Image(.iconBack)
                    }
                    .padding(.leading, 17)
                    Spacer()
                }
                ZStack{
                    EllipticalGradient(
                        stops: [
                            .init(color: .grayText.opacity(0.0), location: 0.2692),
                            .init(color: .white, location: 0.8125)
                        ],
                        center: .center,
                        startRadiusFraction: 0,
                        endRadiusFraction: 0.7431
                    )
                    .frame(width: 360, height: 147)
                    .mask(
                        VStack(spacing: 0){
                            Group{
                                UnevenRoundedRectangle(cornerRadii: .init(
                                    topLeading: 0,
                                    bottomLeading: 12,
                                    bottomTrailing: 12,
                                    topTrailing: 0))
                                .frame(width: 360, height: 123)
                                
                                Triangle()
                                    .foregroundStyle(.grayText)
                                    .frame(width: 93, height: 20)
                            }
                        }
                            
                    )
                    VStack(spacing: 10){
                        Text("Make your own disk")
                            .textStyle(.Title_Text_Eng)
                            .foregroundStyle(.white)
                        Text("오늘 함께할 질문을 작성해보세요.")
                            .textStyle(.Sub_Text_Ko)
                            .foregroundStyle(.white)
                        Spacer().frame(height: 11.75)
                    }
                        
                }
            }
    }
    
    // 질문 카테고리 선택 부분
    var QuestionCategory: some View {
        ZStack {
            UnevenRoundedRectangle(cornerRadii:
                    .init(
                        topLeading: 0,
                        bottomLeading: 12,
                        bottomTrailing: 12,
                        topTrailing: 0))
            .frame(width: 360, height: 423)
            .foregroundStyle(.grayText)
            
            VStack (alignment: .leading) {
                Text("질문 카테고리를")
                    .textStyle(.Title3_Text_Ko)
                    .padding(.leading, 30)
                
                Spacer().frame(height: 5)
                
                Text("선택해주세요.")
                    .textStyle(.Title3_Text_Ko)
                    .padding(.leading, 30)
                Spacer().frame(height: 37)
                
                HStack(spacing:4){
                    CategorySelectButton(title:"선택 1", width: 224, selectedCategory: $selectedCategory)
                    CategorySelectButton(title:"선택 2", width: 132, selectedCategory: $selectedCategory)
                }
                Spacer().frame(height: 20)
                HStack(spacing:4){
                    CategorySelectButton(title:"선택 3", width: 148, selectedCategory: $selectedCategory)
                    CategorySelectButton(title:"선택 4", width: 208, selectedCategory: $selectedCategory)
                }
                Spacer().frame(height: 20)
                HStack(spacing:4){
                    CategorySelectButton(title:"선택 5", width: 184, selectedCategory: $selectedCategory)
                    CategorySelectButton(title:"선택 6", width: 172, selectedCategory: $selectedCategory)
                }
            }
        }
    }
    
    //질문 내용 작성 부분
    var QuestionInput: some View {
        ZStack(alignment: .leading) {
            UnevenRoundedRectangle(cornerRadii:
                    .init(
                        topLeading: 0,
                        bottomLeading: 12,
                        bottomTrailing: 12,
                        topTrailing: 0))
            .frame(width: 360, height: 315)
            .foregroundStyle(.grayText)
            
            VStack (alignment: .leading) {
                Text("질문 내용을")
                    .textStyle(.Title3_Text_Ko)
                    .padding(.leading, 30)
                Spacer().frame(height: 5)
                Text("입력해주세요.")
                    .textStyle(.Title3_Text_Ko)
                    .padding(.leading, 30)
                
                Spacer().frame(height: 15)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .padding(20)
                        .background(Color.white)
                        .textStyle(.Texting_Q)
                        .cornerRadius(12)
                        .frame(width: 320, height: 160)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onChange(of: text, initial: false) {
                            if text.count > 50 {
                                text = String(text.prefix(50))
                            }
                        }

                    if text.isEmpty {
                        Text("내용을 입력해주세요.")
                            .foregroundStyle(.grayText)
                            .textStyle(.Texting_Q)
                            .padding(.top, 30)
                            .padding(.leading, 25)
                    }

                    Text("\(text.count)/50")
                        .foregroundStyle(.grayText)
                        .textStyle(.Small_Text_10)
                        .frame(width: 310, height: 150, alignment: .bottomTrailing)
                }
                .padding(.leading, 19)
            }
        }
    }
    
    //질문 유의사항 부분
    var QuestionCaution: some View {
        ZStack(alignment: .leading){
            VStack(spacing: 0) {
                UnevenRoundedRectangle(cornerRadii:
                        .init(
                            topLeading: 0,
                            bottomLeading: 12,
                            bottomTrailing: 12,
                            topTrailing: 0))
                .frame(width: 360, height: 219)
                .foregroundStyle(.grayBbar)
                
                Triangle()
                    .foregroundStyle(.grayBbar)
                    .frame(width: 93, height: 9)
            }
            
            VStack(alignment: .leading){
                Text("질문 작성시 주의 사항")
                    .textStyle(.Title2_Text_Ko)
                    .foregroundStyle(.warning)
                    .padding(.leading, 28)
                
                Spacer().frame(height: 15)
                
                Text("• 개인정보를 묻지 마세요 (주소, 나이, 연락처 등)\n• 차별적/혐오적/폭력적인 내용은 금지예요\n• 비속어, 선정적인 표현은 삼가주세요\n• 타인이나 단체에 대한 비난은 안 돼요\n• 정치, 종교 등 민감한 주제는 조심스럽게\n• 광고/홍보 목적의 질문은 금지예요\n• 운영 방침에 따라 부적절한 질문은 삭제될 수 있어요")
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.white)
                    .padding(.leading, 19)
            }
            
        }
    }
    
}

// 카테고리 선택 컴포넌트
struct CategorySelectButton: View {
    var title: String
    var width: CGFloat
    
    @Binding var selectedCategory: String?
    
    var isSelected: Bool {
        selectedCategory == title
    }
    
    var body: some View {
        Button(action: {
            if isSelected {
                selectedCategory = nil
            } else {
                selectedCategory = title
            }
        }) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: width, height: 60)
                    .foregroundStyle(isSelected ? Color("key") : .black)
                Text("\(title)")
                    .textStyle(.Q_Main)
                    .foregroundStyle(isSelected ? .black: .white)
                    .padding(.leading, 19)
            }
            
        }
    }
}



#Preview {
    QuestionWriteView(text: "오늘 저녁 뭐먹었어요?")
}
