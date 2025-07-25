//
//  ReportMainView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct ReportMainView: View {
    
    let viewModel = DiscItemViewModel()
    private let columns: [GridItem] = Array(repeating: GridItem(.fixed(91), spacing: 27), count: 3)
    @State private var edit = false
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Image(.imgReportHeaderIcon)
                        .resizable()
                        .frame(width: 14, height: 55)
                    Text(" Disc Museum")
                        .textStyle(.Title_Text_Eng)
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                HStack{
                    Spacer()
                    Button(action:{edit.toggle()}, label:{
                        if edit {
                            Image(.imgDiscOn)
                                .resizable()
                                .frame(width: 60, height: 44)
                        } else {
                            Image(.imgDiscOff)
                                .resizable()
                                .frame(width: 60, height: 44)
                        }
                    })
  
                    Spacer().frame(width: 14)
                }
                
                Spacer().frame(height: 11)
                DiscGroup
            }
        }
    }
    
    
    private var DiscGroup : some View{
        ScrollView(.vertical){
            LazyVGrid(columns: columns){
                ForEach(viewModel.DiscItemList, id: \.id){ item in
                    if edit {
                        Button(action: {}, label: {
                            ZStack{
                                DiscItem(image: item.image)
                                    .padding(.vertical, 10)
                                Image(.imgEdit)
                                    .padding(.leading, 58)
                                    .padding(.bottom, 54)
                            }
                        })
                    } else {
                        Button(action: {}, label: {
                            DiscItem(image: item.image)
                                .padding(.vertical, 10)
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    ReportMainView()
}
