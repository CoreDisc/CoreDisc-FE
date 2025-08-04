//
//  DiscQuestion.swift
//  CoreDisc
//
//  Created by 정서영 on 8/4/25.
//

import SwiftUI

struct DiscQuestion: View {
    let item: TotalDiscModel
    let position: CGPoint
    
    var body: some View {
        HStack {
            Image(item.category == "fixed" ? .iconGreen : .iconRandom)
                .padding(.trailing, 4)
            Text(item.question)
                .textStyle(.Small_Text_10)
                .foregroundStyle(.white)
                .frame(maxWidth: 176)
        }
        .position(position)
    }
}
