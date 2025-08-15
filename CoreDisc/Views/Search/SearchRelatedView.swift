//
//  SearchRelatedView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/23/25.
//
import SwiftUI

struct SearchRelatedView: View {
    let items = Array(0..<5)
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.gray600)
            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 6)
                    
                    ForEach(items, id: \.self) { index in
                        SearchProfileItem(
                            nickname: "뮤직사마",
                            username: "@music_sama",
                            imageURL: nil
                        )
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundStyle(.black000)
                    }
                    .padding(.leading, 8)
                    .padding(.trailing, 28)
                }
            }
        }
        .padding(.horizontal, 25)
        .frame(height: 274)
    }
}

