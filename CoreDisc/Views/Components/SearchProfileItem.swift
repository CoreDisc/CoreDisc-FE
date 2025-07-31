//
//  SearchProfileItem.swift
//  CoreDisc
//
//  Created by 이채은 on 7/23/25.
//
import SwiftUI

struct SearchProfileItem: View {
    var nickname: String
    var id: String
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 32, height: 32)
            Spacer().frame(width: 11.84)
            VStack(alignment: .leading, spacing: 0) {
                HStack{
                    Text("\(nickname)")
                        .textStyle(.Button_s)
                    Spacer()
                }
                HStack{
                    Text("\(id)")
                        .textStyle(.Pick_Q_Eng)
                    Spacer()
                }
            }
            .foregroundStyle(.white)
            .padding(.vertical, 16)
        }
        .padding(.horizontal, 16)
        
    }
}


#Preview {
    SearchProfileItem(nickname: "뮤직사마", id: "@music_sama")
}
