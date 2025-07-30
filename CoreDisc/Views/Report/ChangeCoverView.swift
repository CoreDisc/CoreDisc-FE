//
//  ChangeCoverView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/19/25.
//

import SwiftUI

struct ChangeCoverView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image(.imgGoback)
                            .padding()
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width)
                Spacer().frame(height:108)
                CoverGroup
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var CoverGroup : some View{
        VStack{
            Text("Choose a cover")
                .textStyle(.Title_Text_Eng)
                .foregroundStyle(.white)
            Spacer().frame(height: 42)
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
}


#Preview {
    ChangeCoverView()
}
