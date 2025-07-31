//
//  SummaryQuest.swift
//  CoreDisc
//
//  Created by 정서영 on 7/26/25.
//

import SwiftUI

struct SummaryQuest: View {
    let question: String
    let answer: String
    let freq: String
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                ZStack{
                    Capsule()
                        .frame(width:204, height: 60)
                        .foregroundStyle(.black000)
                    Text(question)
                        .textStyle(.Q_Sub)
                        .foregroundStyle(.highlight)
                }
            }
            HStack{
                ZStack(alignment: .topLeading) {
            
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray800)
                        .frame(width: 274, height: 87)

                    VStack(spacing: 16) {
                        HStack {
                            Text(answer)
                                .textStyle(.Q_Sub)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        HStack {
                            Text(freq)
                                .textStyle(.Q_Main)
                                .foregroundStyle(.white)
                                .offset(x: 50, y: -5)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 16)

                    Circle()
                        .fill(Color.key)
                        .frame(width: 20)
                        .offset(x: 20, y: -10)
                }

                Spacer()
                Capsule().frame(width:2, height: 100)
                    .foregroundStyle(.highlight)
            }
        }
        .padding(.leading, 19)
        .padding(.trailing, 14)
    }
}
