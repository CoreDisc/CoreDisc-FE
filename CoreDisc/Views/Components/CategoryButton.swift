//
//  CategoryButton.swift
//  CoreDisc
//
//  Created by 김미주 on 7/11/25.
//

import SwiftUI

struct CategoryButton: View {
    var title: String
    var startColor: Color
    var endColor: Color
    
    var body: some View {
        Button(action: {}) { // TODO: action 추가
            Text("#\(title)")
                .textStyle(.Q_Sub)
                .foregroundStyle(.gray100)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .linearGradient(
                            startColor: startColor,
                            endColor: endColor)
                )
        }
    }
}

#Preview {
    CategoryButton(title: "카테고리1", startColor: .blue1, endColor: .blue2)
}
