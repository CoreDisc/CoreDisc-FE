//
//  BackModalView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/16/25.
//

import SwiftUI

struct BackModalView: View {
    @Binding var showModal: Bool
    
    let content: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    Text(content)
                        .textStyle(.Button)
                        .foregroundStyle(.black000)
                        .multilineTextAlignment(.center)
                        .frame(height: 92)
                    
                    Divider()
                        .background(.highlight)
                    
                    HStack {
                        Button(action: {
                            showModal = false
                        }) {
                            Text("취소하기")
                                .frame(width: 296, height: 39)
                                .textStyle(.Modal_Text)
                                .foregroundStyle(.black000)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(width: 296, height: 145)
        }
    }
}

//#Preview {
//    BackModalView(content: "안내입니다.\n2줄")
//}
