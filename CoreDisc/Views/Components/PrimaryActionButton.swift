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
    var action: () -> Void
    
    var body: some View {
        //TODO: 버튼 action 추가 필요
        Button(action: action){
            ZStack{
                Rectangle()
                    .cornerRadius(12)
                    .foregroundStyle(isFinished ? .key : .gray400)
                Text(title)
                    .textStyle(.Q_Main)
                    .foregroundStyle(isFinished ? .black000 : .gray600)
                    .padding(.vertical, 18)
            }
            .frame(maxHeight: 60)
            
            
        }
    }
}

#Preview {
    @Previewable @State var tempFinished = false
    
    PrimaryActionButton(title: "확인 및 저장", isFinished: $tempFinished){
        print("click")
    }
}
