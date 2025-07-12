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
            if isSelected {
                selectedCategory = nil
            } else {
                selectedCategory = title
            }
        }) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: width, height: 60)
                    .foregroundStyle(isSelected ? Color("key") : .black)
                Text("\(title)")
                    .textStyle(.Q_Main)
                    .foregroundStyle(isSelected ? .black: .white)
                    .padding(.leading, 19)
            }
            
        }
    }
}
struct CategorySelectButtonPreview: View {
    @State private var selectedCategory: String? = nil

    var body: some View {
        CategorySelectButton(title: "선택1", width: 360, selectedCategory: $selectedCategory)
    }
}

#Preview {
    CategorySelectButtonPreview()
}
