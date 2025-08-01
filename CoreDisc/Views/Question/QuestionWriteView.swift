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
            .init(color: .gray400.opacity(0.0), location: 0.2692),
            .init(color: .white, location: 0.8125)
        ],
        center: .center,
        startRadiusFraction: 0,
        endRadiusFraction: 0.7431
    )
    
    @Environment(\.dismiss) var dismiss
    
    @State var selectedCategory: String? = nil
    @State var text: String = ""
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
                    Button(action: {
                        
                    }) {
                        PrimaryActionButton(title:"확인 및 저장", isFinished: .constant(!text.isEmpty && selectedCategory != nil))
                    }
                    .padding(.horizontal, 21)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(
            Image(.imgLongBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden()
    }
    
    
    // 상단 타이틀
    var WriteSuggestion: some View {
        VStack{
            HStack {
                Button(action: {
                    dismiss()
                }){
                    Image(.iconBack)
                }
                .padding(.leading, 17)
                Spacer()
            }
            ZStack{
                EllipticalGradient(
                    stops: [
                        .init(color: .gray400.opacity(0.0), location: 0.2692),
                        .init(color: .white, location: 0.8125)
                    ],
                    center: .center,
                    startRadiusFraction: 0,
                    endRadiusFraction: 0.7431
                )
                .mask(
                    VStack(spacing: 0){
                        UnevenRoundedRectangle(cornerRadii: .init(
                            topLeading: 0,
                            bottomLeading: 12,
                            bottomTrailing: 12,
                            topTrailing: 0))
                        .padding(.horizontal, 21)
                        
                        Triangle()
                            .foregroundStyle(.gray400)
                            .frame(width: 93, height: 20)
                    }
                    
                )
                VStack(spacing: 10){
                    Text("Make your own disc")
                        .textStyle(.Title_Text_Eng)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                        .padding(.top, 31)
                    Text("오늘 함께할 질문을 작성해보세요.")
                        .textStyle(.Sub_Text_Ko)
                        .foregroundStyle(.white)
                        .padding(.bottom, 48.75)
                    
                }
                
            }
        }
    }
    
    // 질문 카테고리 선택 부분
    var QuestionCategory: some View {
        let categoryPairs: [(CategoryType, CGFloat)] = [
            (.taste, 0.62), (.lifeStyle, 0.38),
            (.relationship, 0.41), (.selfImprovement, 0.59),
            (.health, 0.51), (.culture, 0.49),
            (.feeling, 0.45), (.hobby, 0.55),
            (.dream, 0.3), (.other, 0.7)
        ]
        
        // 🔧 사전에 쌍을 미리 계산해둠
        let pairs = stride(from: 0, to: categoryPairs.count, by: 2).map { i in
            (
                left: (categoryPairs[i].0.title, categoryPairs[i].1),
                right: (categoryPairs[i + 1].0.title, categoryPairs[i + 1].1)
            )
        }
        
        return ZStack {
            UnevenRoundedRectangle(cornerRadii: .init(
                topLeading: 0,
                bottomLeading: 12,
                bottomTrailing: 12,
                topTrailing: 0))
            .foregroundStyle(.gray400)
            .padding(.horizontal, 21)
            
            VStack(alignment: .leading) {
                Text("질문 카테고리를")
                    .textStyle(.Title3_Text_Ko)
                    .padding(.leading, 50)
                    .padding(.top, 28)
                
                Spacer().frame(height: 5)
                
                Text("선택해주세요.")
                    .textStyle(.Title3_Text_Ko)
                    .padding(.leading, 50)
                
                Spacer().frame(height: 37)
                
                VStack(spacing: 20) {
                    ForEach(0..<categoryPairs.count / 2, id: \.self) { i in
                        let left = categoryPairs[i * 2]
                        let right = categoryPairs[i * 2 + 1]
                        
                        ResponsiveCategoryRow(
                            left: left,
                            right: right,
                            selectedCategory: $selectedCategory
                        )
                    }
                }
                .padding(.horizontal, 21)
                .padding(.bottom, 48)
            }
        }
    }
    
    
    //질문 내용 작성 부분
    var QuestionInput: some View {
        ZStack(alignment: .topLeading) {
            UnevenRoundedRectangle(cornerRadii:
                    .init(
                        topLeading: 0,
                        bottomLeading: 12,
                        bottomTrailing: 12,
                        topTrailing: 0))
            .padding(.horizontal, 21)
            .foregroundStyle(.gray400)
            
            VStack (alignment: .leading) {
                Text("질문 내용을")
                    .textStyle(.Title3_Text_Ko)
                    .padding(.top, 30)
                    .padding(.leading, 50)
                Spacer().frame(height: 5)
                Text("입력해주세요.")
                    .textStyle(.Title3_Text_Ko)
                    .padding(.leading, 50)
                
                Spacer().frame(height: 15)
                
                ZStack(alignment: .bottomTrailing) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $text)
                            .padding(20)
                            .background(Color.white)
                            .textStyle(.Texting_Q)
                            .cornerRadius(12)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .onChange(of: text, initial: false) {
                                if text.count > 50 {
                                    text = String(text.prefix(50))
                                }
                            }
                            .frame(height: 160)
                        
                        if text.isEmpty {
                            Text("내용을 입력해주세요.")
                                .foregroundStyle(.gray400)
                                .textStyle(.Texting_Q)
                                .padding(.leading, 23)
                                .padding(.top, 30)
                        }
                    }
                    
                    Text("\(text.count)/50")
                        .foregroundStyle(.gray400)
                        .textStyle(.Small_Text_10)
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                }
                .padding(.horizontal, 41)
                .padding(.bottom, 20)
                
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
                .padding(.horizontal, 21)
                .foregroundStyle(.gray600)
                
                Triangle()
                    .foregroundStyle(.gray600)
                    .frame(width: 93, height: 9)
            }
            
            VStack(alignment: .leading){
                Text("질문 작성시 주의 사항")
                    .textStyle(.Title2_Text_Ko)
                    .foregroundStyle(.warning)
                    .padding(.leading, 50)
                    .padding(.top, 28)
                
                Spacer().frame(height: 15)
                
                Text(" • 개인정보를 묻지 마세요 (주소, 나이, 연락처 등)\n • 차별적/혐오적/폭력적인 내용은 금지예요\n • 비속어, 선정적인 표현은 삼가주세요\n • 타인이나 단체에 대한 비난은 안 돼요\n • 정치, 종교 등 민감한 주제는 조심스럽게\n • 광고/홍보 목적의 질문은 금지예요\n • 운영 방침에 따라 부적절한 질문은 삭제될 수 있어요")
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.white)
                    .padding(.leading, 40)
                    .padding(.bottom, 33)
            }
        }
    }
    
}



#Preview {
    QuestionWriteView()
}
