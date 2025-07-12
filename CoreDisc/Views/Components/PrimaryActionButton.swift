//
//  PrimaryActionButton.swift
//  CoreDisc
//
//  Created by 이채은 on 7/12/25.
//

import SwiftUI

struct PrimaryActionButton: View {
    var title: String
    @Binding var isFinished: Bool
    
    var body: some View {
        //TODO: 버튼 action 추가 필요
        Button(action: {}){
            ZStack{
                Rectangle()
                    .cornerRadius(12)
                    .frame(width: 360, height: 60)
                    .foregroundStyle(isFinished ? .key : .grayText)
                Text(title)
                    .textStyle(.Q_Main)
                    .foregroundStyle(isFinished ? .black : .grayWbg)
            }
            
            
        }
    }
}

#Preview {
    @State var tempFinished = false
    
    PrimaryActionButton(title: "확인 및 저장", isFinished: $tempFinished)
}
