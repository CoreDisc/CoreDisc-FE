//
//  ReportMainView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI
import Kingfisher

struct ReportMainView: View {
    
    @StateObject private var viewModel = ReportMainViewModel()
    private let columns: [GridItem] = Array(repeating: GridItem(.fixed(91), spacing: 27), count: 3)
    @State private var edit = false
    
    var body: some View {
        NavigationStack{
            
            ZStack {
                Image(.imgShortBackground2)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack{
                    HStack{
                        Image(.imgReportHeaderIcon)
                            .resizable()
                            .frame(width: 14, height: 55)
                        Image(.imgGoback)
                        
                        Spacer()
                    }
                    
                    HStack{
                        Text(" Disc Museum")
                            .textStyle(.Title_Text_Eng)
                            .foregroundStyle(.white)
                            .padding(.leading, 25)
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
        .onAppear {
            viewModel.getDiscs()
        }
    }
    
    private var DiscGroup : some View{
        ScrollView(.vertical){
            LazyVGrid(columns: columns){
                ForEach(viewModel.DiscList){ item in
                    if edit {
                        NavigationLink(destination: ChangeCoverView(discId: item.id)){
                            ZStack{
                                DiscItem(
                                    imageUrl: item.imageUrl,
                                    localImageName: item.localImageName,
                                    dateLabel: item.dateLabel)
                                .padding(.vertical, 10)
                                Image(.imgEdit)
                                    .offset(x:30, y:30)
                            }
                        }
                    } else {
                        NavigationLink(destination: ReportDetailView(discId: item.id)){
                            DiscItem(
                                imageUrl: item.imageUrl,
                                localImageName: item.localImageName,
                                dateLabel: item.dateLabel)
                            .padding(.vertical, 10)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ReportMainView()
}
