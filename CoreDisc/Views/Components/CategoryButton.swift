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

    @State private var isSelected: Bool = false

    var body: some View {
        Button(action: {
            isSelected.toggle() // TODO: action 추가
        }) {
            Text("#\(title)")
                .textStyle(.Q_Sub)
                .foregroundStyle(.gray100)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                colors: [startColor, endColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                )
                .padding(3)
        }
    }
}

#Preview {
    CategoryButton(title: "카테고리1", startColor: .blue1, endColor: .blue2)
}
