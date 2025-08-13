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
    
    @StateObject private var viewModel = SearchMemberViewModel()
    
    var body: some View {
        ZStack {
            Image(.imgSearchBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 11)
                
                SearchBarGroup(
                    query: $query,
                    isSearch: $isSearch,
                    onSearch: {
                        if let path {
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
        .task {
            isSearch = false
            if !query.isEmpty {
                viewModel.startSearch(keyword: query, record: true)
            }
        }
        .onChange(of: query) { _, newValue in
            if !newValue.isEmpty, isSearch == false {
                viewModel.startSearch(keyword: newValue, record: true)
            }
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
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.items) { user in
                                SearchProfileItem(
                                    nickname: user.nickname,
                                    username: "@\(user.username)",
                                    imageURL: user.profileImgDTO?.imageUrl
                                )
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(current: user)
                                }
                                
                                Rectangle()
                                    .frame(height: 0.5)
                                    .foregroundStyle(.gray600)
                                    .padding(.horizontal, 24)
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding(.vertical, 16)
                            } else if viewModel.items.isEmpty {
                                Text("No results")
                                    .textStyle(.Pick_Q_Eng)
                                    .foregroundStyle(.gray200)
                                    .padding(.vertical, 24)
                            }
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
