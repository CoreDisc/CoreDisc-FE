//
//  CorelistToggle.swift
//  CoreDisc
//
//  Created by 김미주 on 7/18/25.
//

import SwiftUI

struct CorelistToggle: View {
    @State private var isCorelist: Bool = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isCorelist.toggle()
            }
        }) {
            ZStack(alignment: isCorelist ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.gray800)
                    .frame(width: 60, height: 32)
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(isCorelist ? .black000 : .gray600)
                    .frame(width: 56, height: 28)
                    .padding(.horizontal, 2)
                
                Image(.iconCore)
                    .foregroundStyle(isCorelist ? .key : .gray400)
                    .padding(.horizontal, 4)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CorelistToggle()
}
