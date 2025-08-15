//
//  TermsView.swift
//  CoreDisc
//
//  Created by 정서영 on 8/12/25.
//

import SwiftUI

struct TermsView: View {
    
    let essential: Bool
    let text: String
    let isChecked: Bool
    let toggle: () -> Void
    let action: () -> Void
    
    init(essential: Bool, text: String, isChecked: Bool, toggle: @escaping () -> Void, action: @escaping () -> Void) {
        self.essential = essential
        self.text = text
        self.isChecked = isChecked
        self.toggle = toggle
        self.action = action
    }
    
    var body: some View {
        HStack{
            Button(action:{
                toggle()
            }, label:{
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.white)
                    
                    if isChecked {
                        Image(.iconChecking)
                    }
                }
            })
            
            if(essential){
                Text("(필수)")
                    .textStyle(.Button_s)
                    .foregroundStyle(.warning)
            } else{
                Text("(선택)")
                    .textStyle(.Button_s)
                    .foregroundStyle(.white)
            }
            
            Text(text)
                .textStyle(.Button_s)
                .foregroundStyle(.white)
            
            Spacer()
            
            Button(action: {
                action()
            }, label: {
                ZStack{
                    Capsule()
                        .frame(width: 72, height: 22)
                        .foregroundStyle(.highlight)
                    Text("전문 펼쳐보기")
                        .textStyle(.Small_Text_10)
                        .foregroundStyle(.gray800)
                }
            })
        }
    }
}
