//
//  SearchResultView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/22/25.
//

import SwiftUI

struct SearchResultView: View {
    @Binding var query:String
    @Binding var isSearch: Bool
    var path: Binding<NavigationPath>? = nil
    let items = Array(0..<20)
    
    var body: some View {
        ZStack {
            Image(.imgSearchBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 11)
                SearchBarGroup(query: $query, isSearch: $isSearch, onSearch: {
                    if let path = path {
                        path.wrappedValue = NavigationPath()
                        path.wrappedValue.append(UUID())
                    }
                },
                               path: path
                )
                Spacer().frame(height: isSearch ? 18 : 21)
                
                ResultGroup
                
                Spacer()
            }
            
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            isSearch = false
        }
    }
    
    private var ResultGroup: some View {
        VStack {
            if isSearch {
                SearchRelatedView()
                
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Accounts")
                        .textStyle(.Pick_Q_Eng)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 13)
                    
                    ScrollView{
                        ForEach(items.indices, id: \.self) {index in
                            SearchProfileItem(nickname: "뮤직사마", id: "@music_sama")
                            Spacer().frame(height: 0)
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundStyle(.gray600)
                            Spacer().frame(height: 0)
                        }
                        .padding(.horizontal, 24)
                        
                    }
                }
            }
        }
    }
}

private struct SearchResultViewPreviewWrapper: View {
    @State var tempQuery = ""
    @State var tempSearch = false
    
    var body: some View {
        SearchResultView(query: $tempQuery, isSearch: $tempSearch)
    }
}

#Preview {
    SearchResultViewPreviewWrapper()
}
