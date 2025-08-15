//
//  QuestionTrendingView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/21/25.
//

import SwiftUI


struct QuestionTrendingView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = PopularQuestionViewModel()
    
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
        }
        .navigationBarBackButtonHidden()
        .task {
            viewModel.fetchPopularQuestions()
        }
        
    }
    
    
    var TopGroup: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action:{
                    dismiss()
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
                        isFavorite: false
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
                    isChecked.toggle()
                }){
                    Image(isChecked ? .iconChecked : .iconCheck)
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            }
        }
        
    }
}

#Preview {
    QuestionTrendingView()
}
