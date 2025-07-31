//
//  ChangeCoverView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/19/25.
//

import SwiftUI

struct ChangeCoverView: View {
    @Environment(\.dismiss) var dismiss
    let viewModel = ChangeCoverViewModel()
    private let columns: [GridItem] = Array(repeating: GridItem(.fixed(80), spacing: 26), count: 3)
    @State var cover: String = ""
    
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
                Spacer().frame(height:52)
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
            Spacer().frame(height: 37)
            
            LazyVGrid(columns: columns, spacing: 35){
                ForEach(viewModel.CoverList, id: \.color){ item in
                    Button(action:{
                        cover=item.color
                    }, label:{
                        if cover == item.color{
                            item.image
                                .resizable()
                                .frame(width: 76, height: 76)
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 3))
                        } else
                        {
                            item.image
                                .resizable()
                                .frame(width: 76, height: 76)
                        }
                        
                    })
                }
                
                Button(action:{cover=""}, label:{
                    Image(.imgCoverChange)
                        .resizable()
                        .frame(width: 76, height: 76)
                })
            }
            
            Spacer().frame(height: 43)
            
            Button(action:{}, label:{
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.key)
                        .frame(height:60)
                    
                    Text("확인 및 저장")
                        .textStyle(.Q_Main)
                        .foregroundStyle(.black000)
                }
            })
        }
        .padding(.horizontal, 21)
    }
}


#Preview {
    ChangeCoverView()
}
