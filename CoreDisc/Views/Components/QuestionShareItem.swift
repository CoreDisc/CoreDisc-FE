//
//  QuestionShareItem.swift
//  CoreDisc
//
//  Created by 이채은 on 7/19/25.
//
import SwiftUI



struct QuestionShareItem: View {
    var type: String
    var category: String
    var content: String
    var date: String
    var index: Int
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .key, radius: 2, x: 0, y: 0)
                .frame(height: 115)
                
            
            VStack(spacing: 5) {
                HStack {
                    Text("\(index)") // 디자인 시스템 없음
                        .font(.pretendard(type: .bold, size: 12))
                        .frame(width: 20, height: 20)
                        .background(
                            Circle()
                                .fill(.highlight)
                        )
                        .padding(.leading, 10)
                        .padding(.top, 11)
                    
                    Spacer()
                    if type == "share" {
                        Button(action: {}) {
                            Image(.iconShare)
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                        .padding(.top, 11)
                        
                        Spacer().frame(width: 5)
                        
                        Text("16")
                            .font(.pretendard(type: .regular, size: 12))
                            .padding(.trailing, 17)
                            .padding(.top, 11)
                    } else {
                        Button(action: {}) {
                            Image(.iconHeart)
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                        .padding(.top, 11)
                        
                        Button(action: {
                            onDelete?()
                        }) { // TODO: action
                            Image(.iconClose)
                                .renderingMode(.original)
        
                        }
                        .padding(.trailing, 17)
                        .padding(.top, 11)
                    }
                }
                
                Spacer().frame(height: 4)
                
                Text(content.splitCharacter())
                    .textStyle(.Texting_Q)
                    .foregroundStyle(.black000)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 15)
                
                
                Spacer().frame(height: 14)
                
                HStack(spacing: 5) {
                    Spacer()
                    
                    Text(category) // 디자인 시스템 없음
                        .font(.pretendard(type: .regular, size: 8))
                        .kerning(-0.7)
                        .padding(.bottom, 5)
        
                    
                    Text(date) // 디자인 시스템 없음
                        .font(.pretendard(type: .regular, size: 8))
                        .kerning(-0.7)
                        .padding(.trailing, 17)
                        .padding(.bottom, 5)
                }
                
            }
        }
        
    }
}

#Preview {
    QuestionShareItem(type: "share", category: "카테고리1", content: "맛있는 음식을 먹을 때 어떤 기분이 드나요? 표현해본다면요? 맛있는 음식을 먹을 때 어떤 ", date: "25년 8월 1일", index: 1)
}
