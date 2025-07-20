//
//  CategorySelectButton.swift
//  CoreDisc
//
//  Created by 이채은 on 7/13/25.
//

import SwiftUI

// 카테고리 선택 컴포넌트
struct CategorySelectButton: View {
    var title: String
        var width: CGFloat
        @Binding var selectedCategory: String?

        var isSelected: Bool {
            selectedCategory == title
        }

        var body: some View {
            Button(action: {
                selectedCategory = isSelected ? nil : title
            }) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(isSelected ? Color("key") : .black)
                    Text(title)
                        .padding(.leading, 19)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(isSelected ? .black : .white)
                }
                .frame(width: width, height: 60)
            }
        }
}

//카테고리 선택 열
struct ResponsiveCategoryRow: View {
    var left: (String, CGFloat)
    var right: (String, CGFloat)
    @Binding var selectedCategory: String?

    var body: some View {
        GeometryReader { geo in
            let total = geo.size.width
            let leftWidth = total * left.1 - 4 * left.1
            let rightWidth = total * right.1 - 4 * right.1

            HStack(spacing: 4) {
                CategorySelectButton(title: left.0, width: leftWidth, selectedCategory: $selectedCategory)
                CategorySelectButton(title: right.0, width: rightWidth, selectedCategory: $selectedCategory)
            }
        }
        .frame(height: 60)
    }
}

