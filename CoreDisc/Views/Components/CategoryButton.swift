//
//  CategoryButton.swift
//  CoreDisc
//
//  Created by 김미주 on 7/11/25.
//

import SwiftUI

struct CategoryButton: View {
    let type: CategoryType

    @State private var isSelected: Bool = false

    var body: some View {
        switch type.style {
        case .all:
            Button(action: {
                isSelected.toggle()
            }) { //TODO: Action 추가
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
                isSelected.toggle() // TODO: action 추가
            }) {
                Text("\(type.title)")
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.gray100)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(
                                type.color
                            )
                            .frame(width: 75, height: 28)

                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                            .frame(width: 75, height: 28)
                    )
                    .padding(3)
            }
            .frame(width: 75, height: 28)
        }
    }
}

#Preview {
    CategoryButton(type: .meal)
}
