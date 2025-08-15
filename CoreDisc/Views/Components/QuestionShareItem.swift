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
    var sharedCount: Int
    var index: Int
    var onDelete: (() -> Void)? = nil
    var onTap: (() -> Void)
    @State var isChecked: Bool = false
    
    @ObservedObject var selectViewModel: QuestionBasicViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .key, radius: 2, x: 0, y: 0)
                .frame(height: 115)
                
            
            VStack(alignment: .leading, spacing: 5) {
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
                    
                    Image(isChecked ? .iconChecked : .iconCheck)
                        .resizable()
                        .renderingMode(isChecked ? .template : .original)
                        .foregroundColor(isChecked ? .key : nil)
                        .frame(width: 18, height: 18)
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
                        
                        Text("\(sharedCount)")
                            .font(.pretendard(type: .regular, size: 12))
                            .foregroundStyle(.black000)
                            .padding(.trailing, 17)
                            .padding(.top, 11)
                    } else {
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
                        .foregroundStyle(.black000)
                        .padding(.bottom, 5)
        
                    
                    Text(formatDate(date)) // 디자인 시스템 없음
                        .font(.pretendard(type: .regular, size: 8))
                        .kerning(-0.7)
                        .foregroundStyle(.black000)
                        .padding(.trailing, 17)
                        .padding(.bottom, 5)
                }
                
            }
        }
        .onTapGesture {
            onTap()
        }
    }
    
    private func formatDate(_ isoDate: String) -> String {
        let trimmed = isoDate.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        if let date = inputFormatter.date(from: trimmed) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR")
            outputFormatter.dateFormat = "yy년 M월 d일"
            return outputFormatter.string(from: date)
        }
        return isoDate
    }

}

