//
//  ButtonView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/30/25.
//

import SwiftUI

struct ButtonView<Content: View>: View {
    
    let label: Content
    let action: () -> Void
    
    init(action: @escaping () -> Void, @ViewBuilder label: () -> Content) {
        self.label = label()
        self.action = action
    }
    
    var body: some View {
        Button(action:{
            action()
        }, label: {
            ZStack{
                Rectangle()
                    .frame(height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(.gray400)
                label
                    .textStyle(.login_info)
                    .foregroundStyle(.black000)
            }
        })
    }
}
