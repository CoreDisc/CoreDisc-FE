//
//  DiscItem.swift
//  CoreDisc
//
//  Created by 정서영 on 7/19/25.
//

import SwiftUI
import Kingfisher

struct DiscItem: View {
    let imageUrl: String?
    let localImageName: String?
    let dateLabel: String
    
    var body: some View {
        ZStack(alignment: .leading){
            Rectangle()
                .fill(Color.clear)
                .frame(width: 47, height: 92)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(.highlight), Color(.gray600)]),
                        startPoint: UnitPoint(x: 0.8, y: 0.3), endPoint: UnitPoint(x: 0.2, y: 1.4)
                    )
                )
                .cornerRadius(12, corners: [.topLeft, .bottomLeft])
            
            if let urlString = imageUrl,
               let url = URL(string: urlString),
               !urlString.isEmpty {
                KFImage(url)
                    .frame(width: 86, height: 86)
                    .padding(.leading, 5)
            } else if let localName = localImageName {
                Image(localName)
                    .resizable()
                    .frame(width: 86, height: 86)
                    .padding(.leading, 5)
            } else {
                Image(.imgBasicDisc)
                    .frame(width: 86, height: 86)
                    .padding(.leading, 5)
            }
            
            Text(dateLabel)
                .textStyle(.Small_Text_10)
                .foregroundStyle(.white)
                .offset(x:10, y:-35)
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
        }
    }
}
