//
//  SearchView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct SearchView: View {
    @Binding var query:String
    @Binding var isSearch: Bool
    @State private var path = NavigationPath()
    let items = Array(0..<5)
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Image(.imgSearchBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 11)
                    SearchBarGroup(query: $query, isSearch: $isSearch, onSearch: {
                        path.append(UUID()) // 🔥 매번 다른 값 push
                    })
                    Spacer().frame(height: isSearch ? 18 : 21)
                    SearchGroup
                    Spacer()
                }
            }
            .navigationDestination(for: UUID.self) { _ in
                SearchResultView(query: $query, isSearch: $isSearch, path: $path)
            }
        }
    }
    
    
    
    private var SearchGroup: some View {
        VStack {
            if isSearch {
                SearchRelatedView()
            } else {
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

private struct SearchViewPreviewWrapper: View {
    @State var tempQuery = ""
    @State var tempSearch = false
    
    var body: some View {
        SearchView(query: $tempQuery, isSearch: $tempSearch)
    }
}

#Preview {
    SearchViewPreviewWrapper()
}
