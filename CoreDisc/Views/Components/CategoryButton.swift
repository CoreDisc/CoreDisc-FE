//
//  CategoryButton.swift
//  CoreDisc
//
//  Created by 김미주 on 7/11/25.
//

import SwiftUI

struct CategoryButton: View {
    let type: CategoryType
    @Binding var selectedCategoryId: Int?
    let onSelect: (Int) -> Void

    var body: some View {
        let isSelected = selectedCategoryId == type.id || (type.style == .all && selectedCategoryId == 0)

        switch type.style {
        case .all:
            Button(action: {
                selectedCategoryId = 0
                onSelect(0)
            }) {
                ZStack {
                    EllipticalGradient(
                        stops: [
                            .init(color: .gray400.opacity(0.0), location: 0.2692),
                            .init(color: .white, location: 0.8125)
                        ],
                        center: .center,
                        startRadiusFraction: 0,
                        endRadiusFraction: 0.7431
                    )
                    .frame(width: 75, height: 28)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.white, lineWidth: isSelected ? 3 : 0)
                    )
                    .padding(3)

                    Text("ALL")
                        .textStyle(.Q_Sub)
                        .foregroundStyle(.white)
                }
            }

        default:
            Button(action: {
                selectedCategoryId = type.id
                onSelect(type.id)
            }) {
                Text("#\(type.title)")
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.gray100)
                    .background(
                        Group {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(type.color)
                                .frame(width: type == .lifeStyle ? 90 : 75, height: 28)
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                            .frame(width: type == .lifeStyle ? 90 : 75, height: 28)
                    )
                    .padding(3)
            }
            .frame(width: type == .lifeStyle ? 90 : 75)
        }
    }
}
