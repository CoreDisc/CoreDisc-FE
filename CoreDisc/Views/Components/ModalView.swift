//
//  ModalView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/17/25.
//

import SwiftUI

struct ModalView<Content: View, LeftButton: View, RightButton: View>: View {
    let content: Content
    let leftButton: LeftButton
    let rightButton: RightButton
    
    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder leftButton: () -> LeftButton,
        @ViewBuilder rightButton: () -> RightButton
    ) {
        self.content = content()
        self.leftButton = leftButton()
        self.rightButton = rightButton()
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    content
                        .frame(height: 92)
                        .foregroundStyle(.black000)
                    
                    Divider()
                        .background(.highlight)
                    
                    HStack {
                        leftButton
                            .frame(width: 148, height: 39)
                            .textStyle(.Modal_Text)
                            .foregroundStyle(.black000)
                            .buttonStyle(.plain)
                        
                        rightButton
                            .frame(width: 148, height: 39)
                            .textStyle(.Modal_Text)
                            .foregroundStyle(.black000)
                            .buttonStyle(.plain)
                    }
                }
            }
            .frame(width: 296, height: 145)
        }
    }
}

#Preview {
    ModalView {
        VStack(spacing: 10) {
            Text("차단하면 서로의 게시글과 활동을 볼 수 없습니다.")
                .textStyle(.Button_s)
            
            Text("차단하시겠습니까?")
                .textStyle(.Button_s)
        }
    } leftButton: {
        Button(action: {}) {
            Text("취소하기")
        }
    } rightButton: {
        Button(action: {}) {
            Text("차단하기")
                .foregroundStyle(.red)
        }
    }
}
