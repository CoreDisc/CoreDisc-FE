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
                VStack {
                    Spacer().frame(height: 6)
                    
                    ForEach(items.indices, id: \.self) {index in
                        Spacer().frame(height: 0)
                        SearchProfileItem(nickname: "뮤직사마", id:
                                            "music_sama")
                        Spacer().frame(height: 0)
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
