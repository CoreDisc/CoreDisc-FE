//
//  QuestionTrendingView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/21/25.
//

import SwiftUI


struct QuestionTrendingView: View {
    @Environment(NavigationRouter<QuestionRoute>.self) private var router
    
    @State var goToMain: Bool = false
    
    @StateObject private var viewModel = PopularQuestionViewModel()
    @StateObject private var basicviewModel = QuestionBasicViewModel()
    
    let selectedQuestionType: String
    
    // 질문 선택/저장 용도
    let order: Int
    @State private var selectedQuestionId: Int? = nil
    @State var showSelectModal: Bool = false
    
    var body: some View {
        
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                
                TopGroup
                
                RankingGroup
                
                
                Spacer()
            }
            
            // 선택 확인 모달
            if showSelectModal {
                QuestionSelectModalView(
                    isMonth: selectedQuestionType,
                    selectedQuestionId: $selectedQuestionId,
                    order: order,
                    selectedQuestionType: .OFFICIAL,
                    viewModel: basicviewModel,
                    showSelectModal: $showSelectModal,
                    goToMain: $goToMain
                )
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            viewModel.fetchPopularQuestions()
        }
        .fullScreenCover(isPresented: $goToMain) { TabBar(startTab: .disk) }
    }
    
    
    var TopGroup: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action:{
                    router.pop()
                }) {
                    Image(.iconBack)
                        .resizable()
                        .frame(width: 42, height: 42)
                }
                .padding(.leading, 17)
                Spacer()
            }
            
            Spacer().frame(height: 7)
            
            Text("Trending Question")
                .textStyle(.Title_Text_Ko)
                .foregroundStyle(.key)
                .padding(.leading, 16)
            
            Spacer().frame(height: 4)
            
            Text("\(viewModel.startDate) - \(viewModel.endDate)")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 20)
            
            Spacer().frame(height: 28)
            
            Text("POPULAR")
                .textStyle(.Q_Main)
                .foregroundStyle(.warning)
                .padding(.leading, 45)
            
        }
    }
    
    var RankingGroup: some View {
        VStack {
            ForEach(viewModel.questions.indices, id: \.self){index in
                let question = viewModel.questions[index]
                VStack(alignment: .leading) {
                    TrendingQuestionItem(
                        index: index + 1,
                        content: question.question,
                        nickname: question.username,
                        sharing: question.sharedCount,
                        isChecked: question.isSelected,
                        isFavorite: false,
                        onTap: {
                            showSelectModal = true
                            selectedQuestionId = question.id
                        }
                    )
                    .padding(.leading, 43)
                    .padding(.trailing, 47)
                    
                    Rectangle()
                        .foregroundStyle(.white)
                        .padding(.horizontal, 31)
                        .frame(height: 0.4)
                }
                
            }
        }
    }
}

struct TrendingQuestionItem: View {
    var index: Int
    var content: String
    var nickname: String
    var sharing: Int
    @State var isChecked: Bool
    @State var isFavorite: Bool
    var onTap: (() -> Void)
    
    var body: some View {
        VStack {
            HStack {
                Text("\(index)")
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .frame(width:24, height: 24)
                            .foregroundStyle(.gray600)
                    )
                
                VStack(alignment: .leading) {
                    Text("\(content.splitCharacter())")
                        .textStyle(.Texting_Q)
                        .foregroundStyle(.white)
                        .padding(.leading, 8)
                        .padding(.top, 12)
                        .padding(.bottom, 4)
                        .padding(.trailing, 14)
                    
                    HStack(spacing: 7){
                        Text("@\(nickname)")
                            .textStyle(.Comment_ID)
                            .foregroundStyle(.gray200)
                        Text("\(sharing)회")
                            .textStyle(.Small_Text)
                            .foregroundStyle(.gray200)
                    }
                    .padding(.leading, 8)
                    .padding(.bottom, 4)
                    
                }
                
                Spacer()
                
                Button(action:{
                    onTap()
                }){
                    Image(isChecked ? .iconChecked : .iconCheck)
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            }
        }
    }
}

//#Preview {
//    QuestionTrendingView()
//}
