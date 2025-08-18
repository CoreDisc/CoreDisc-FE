//
//  ChangeCoverView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/19/25.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct ChangeCoverView: View {
    @Environment(NavigationRouter<ReportRoute>.self) private var router
    
    @StateObject var viewModel = ReportMainViewModel()
    private let columns: [GridItem] = Array(repeating: GridItem(.fixed(80), spacing: 26), count: 3)
    @State var cover: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    let discId: Int
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button(action: {
                        router.pop()
                    }){
                        Image(.imgGoback)
                            .padding()
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width)
                CoverGroup
                Spacer().frame(height:52)
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
                ForEach(viewModel.colors, id: \.self){ color in
                    Button(action:{
                        cover = color
                    }, label:{
                        
                        let image = Image(viewModel.imageNameForColor(color))
                            .resizable()
                            .frame(width: 76, height: 76)
                        
                        if cover == color {
                            image.overlay(
                                Circle().stroke(Color.white, lineWidth: 3)
                            )
                        } else {
                            image
                        }
                    })
                }
                
                VStack {
                    PhotosPicker(
                        selection: $selectedItem, matching: .images
                    ) {
                        if let data = selectedImageData,
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 76, height: 76)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 3)
                                )
                        } else {
                            Image(.imgCoverChange)
                                .resizable()
                                .frame(width: 76, height: 76)
                        }
                    }
                    .onChange(of: selectedItem) { oldValue, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }
                }
            }
            
            Spacer().frame(height: 43)
            
            Button(action:{
                viewModel.ChangeCover(discId: discId, coverColor: cover)
            }, label:{
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.key)
                        .frame(height:60)
                    
                    Text("수정하기")
                        .textStyle(.Q_Main)
                        .foregroundStyle(.black000)
                }
            })
            .onChange(of: viewModel.colorChangeSuccess) { oldValue, newValue in
                if newValue {
                    router.pop()
                }
            }
        }
        .padding(.horizontal, 21)
    }
    
}


#Preview {
    ChangeCoverView(discId: 1)
}
