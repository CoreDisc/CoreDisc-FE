//
//  ChangeCoverView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/19/25.
//

import SwiftUI

struct ChangeCoverView: View {
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            VStack{
                Text("Choose a cover")
                    .textStyle(.Title_Text_Eng)
                    .foregroundStyle(.white)
                Spacer().frame(height: 42)
                CoverGroup
            }
        }
    }
    
    //애니메이션 추가해야함
    private var CoverGroup : some View{
        HStack{
            Image(.imgOrangeCover)
            Spacer().frame(width: 23)
            
            Button(action:{}, label:{
                Image(.imgCoverChange)
            })
            
            Spacer().frame(width: 23)
            Image(.imgBlueCover)
        }
    }
}

#Preview {
    ChangeCoverView()
}
