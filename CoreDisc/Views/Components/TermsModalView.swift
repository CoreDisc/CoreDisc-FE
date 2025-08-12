//
//  TermsModalView.swift
//  CoreDisc
//
//  Created by 정서영 on 8/12/25.
//

import SwiftUI

struct TermsModalView: View {
    
    let essential: Bool
    let title: String
    let action: () -> Void
    let content: String
    
    init(essential: Bool, title: String, action: @escaping () -> Void, content: String) {
        self.essential = essential
        self.title = title
        self.action = action
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.gray800)
                
                VStack{
                    Spacer()
                    HStack{
                        if(essential){
                            Text("(필수)")
                                .textStyle(.Title2_Text_Ko)
                                .foregroundStyle(.warning)
                        } else{
                            Text("(선택)")
                                .textStyle(.Title2_Text_Ko)
                                .foregroundStyle(.white)
                        }
                        Text(title)
                            .textStyle(.Title2_Text_Ko)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Button(action:{
                            action()
                        }, label:{
                            Image(.iconX)
                        })
                    }
                    .padding(.vertical, 10)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.white)
                        ScrollView{
                            LazyVStack{
                                Text(content)
                                    .padding(10)
                            }
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 26)
            }
            .frame(maxHeight: 600)
            .padding(20)
        }
    }
}
