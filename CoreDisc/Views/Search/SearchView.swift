//
//  SearchView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct SearchView: View {
    @State var query: String = ""
    @State var isSearch: Bool = false
    @State private var path = NavigationPath()
    @StateObject private var viewModel = SearchHistoryViewModel()
    
    var body: some View {
        ZStack {
            Image(.imgSearchBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 11)
                SearchBarGroup(query: $query, isSearch: $isSearch, onSearch: {
                    path.append(UUID())
                })
                Spacer().frame(height: isSearch ? 18 : 21)
                SearchGroup
                Spacer()
            }
        }
        .task {
            if viewModel.items.isEmpty { viewModel.refresh() }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var SearchGroup: some View {
        VStack {
            if isSearch {
                SearchRelatedView()
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Searches")
                        .textStyle(.Pick_Q_Eng)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.items) { item in
                                RecentItem(
                                    text: item.keyword,
                                    isDeleting: viewModel.deletingIds.contains(item.id),
                                    onDelete: { viewModel.deleteHistory(id: item.id) }
                                )
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(current: item)
                                }
                                
                                Rectangle()
                                    .frame(height: 0.5)
                                    .foregroundStyle(.gray600)
                                    .padding(.horizontal, 33)
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding(.vertical, 12)
                            }
                        }
                        .padding(.horizontal, 33)
                    }
                    .frame(height: 274)
                }
            }
        }
    }
}

struct RecentItem: View {
    let text: String
    var isDeleting: Bool = false
    var onDelete: () -> Void = {}
    
    var body: some View {
        HStack {
            Text(text)
                .textStyle(.Q_Main)
                .foregroundStyle(.white)
                .padding(.leading, 30)
            
            Spacer()
            
            if isDeleting {
                ProgressView()
                    .frame(width: 24, height: 24)
            } else {
                Button(action: onDelete) {
                    Image(.iconClose)
                        .resizable()
                        .padding(.trailing, 36)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.white)
                    
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}

//#Preview {
//    SearchView()
//}
