//
//  InputView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/30/25.
//

import SwiftUI

struct InputView<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack{
            Capsule()
                .frame(height: 40)
                .foregroundStyle(.white)
            content
                .textStyle(.login_info)
                .padding(.leading, 31)
        }
    }
}
