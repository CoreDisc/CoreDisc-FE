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
            if let urlString = imageUrl,
               let url = URL(string: urlString),
               !urlString.isEmpty {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 86, height: 86)
                    .clipShape(Circle())
                    .padding(.leading, 5)
            } else if let localName = localImageName {
                Image(localName)
                    .resizable()
                    .frame(width: 86, height: 86)
                    .clipShape(Circle())
                    .padding(.leading, 5)
            } else {
                Image(.imgBasicDisc)
                    .frame(width: 86, height: 86)
                    .clipShape(Circle())
                    .padding(.leading, 5)
            }
            
            Text(dateLabel)
                .textStyle(.Q_Main)
                .foregroundStyle(.white)
                .offset(y:-30)
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
        }
    }
}
