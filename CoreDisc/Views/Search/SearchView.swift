//
//  SearchView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct SearchView: View {
    @State var query:String
    let items = Array(0..<5)
    
    var body: some View {
        ZStack {
            Image(.imgSearchBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 11)
                searchGroup
                Spacer().frame(height: 21)
                recentSearchGroup
                Spacer()
            }
        }
    }
    
    private var searchGroup: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.key)
                .frame(width: 28, height: 114)
                .offset(x: -14)
            
            Spacer().frame(width: 11)
            
            VStack(alignment: .leading) {
                Text("Explore")
                    .textStyle(.Title_Text_Eng)
                    .foregroundStyle(.white)
                Spacer().frame(height: 14)
                HStack {
                    ZStack(alignment: .leading) {
                        TextEditor(text: $query)
                            .padding(.leading, 46)
                            .padding(.top, 5)
                            .background(.white)
                            .textStyle(.Pick_Q_Eng)
                            .cornerRadius(32)
                            .shadow(color: .white.opacity(0.5), radius: 4.8, x: 0, y: 0)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .frame(height: 45)
                        
                            HStack(spacing: 11) {
                                Image(.iconSearch)
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .padding(.leading, 17)
                                
                                if query.isEmpty {
                                    Text("Enter a user's name or ID")
                                        .textStyle(.Pick_Q_Eng)
                                        .foregroundStyle(.gray200)
                                        .padding(.vertical, 12.5)
                                        .padding(.leading, 2)
                                }
                            }
                        
                    }
                    .padding(.trailing, 25)
                }
                
            }
        }
    }
    
    private var recentSearchGroup: some View {
        VStack(alignment: .leading) {
            Text("Recent Searches")
                .textStyle(.Pick_Q_Eng)
                .foregroundStyle(.white)
                .padding(.horizontal, 30)
            
            Spacer().frame(height: 8)
            
            ForEach(items.indices, id: \.self) {index in
                RecentItem(text: "music")
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundStyle(.gray600)
            }
            .padding(.horizontal, 33)
            
        }
    }
}

struct RecentItem: View {
    let text: String
    
    var body: some View {
        
        HStack {
            Text("\(text)")
                .textStyle(.Q_Main)
                .foregroundStyle(.white)
            
            Spacer()
            
            Image(.iconClose)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}

#Preview {
    SearchView(query: "헷")
}
