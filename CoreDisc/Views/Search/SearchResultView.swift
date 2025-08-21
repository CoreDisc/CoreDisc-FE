//
//  SearchResultView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/22/25.
//
import SwiftUI

struct SearchResultView: View {
    @State private var query: String
    @Binding var isSearch: Bool
    
    @State private var isTyping: Bool = false
    @State private var isSubmitted: Bool = false
    
    @StateObject private var viewModel = SearchMemberViewModel()
    
    @Environment(NavigationRouter<PostRoute>.self) var router
    
    @FocusState private var isFocused: Bool
    
    var myUsername: String
    
    init(initialQuery: String,
         isSearch: Binding<Bool> = .constant(false),
         myUsername: String
    ) {
        _query = State(initialValue: initialQuery)
        self._isSearch = isSearch
        self.myUsername = myUsername
    }
    
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
                        if !query.isEmpty {
                            isSubmitted = true
                            isTyping = false
                            viewModel.startSearch(keyword: query, record: true)
                        }
                    },
                    isFocused: $isFocused
                )
                
                Spacer().frame(height: (isTyping || isSearch) ? 18 : 21)
                ResultGroup
                Spacer().frame(height: 75)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
        }
        .navigationBarBackButtonHidden()
        .task {
            if !query.isEmpty {
                isSubmitted = true
                viewModel.startSearch(keyword: query, record: true)
            }
        }
        .onChange(of: query) { _, newValue in
            if newValue.isEmpty {
                isTyping = false
            } else {
                isTyping = true
                isSubmitted = false
            }
        }
    }
    
    private var ResultGroup: some View {
        VStack {
            if isTyping {
                SearchRelatedView(viewModel: viewModel,
                                  keyword: query,
                                  myUsername: myUsername)
            } else if isSubmitted {
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
                                    imageURL: user.profileImgDTO?.imageUrl,
                                    onTap: {
                                        if user.username == myUsername {
                                            router.push(.myHome)
                                        } else {
                                            router.push(.user(userName: user.username))
                                        }
                                    }
                                )
                                .task {
                                    viewModel.loadMoreIfNeeded(current: user)
                                }
                                
                                Rectangle()
                                    .frame(height: 0.5)
                                    .foregroundStyle(.gray600)
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
            } else {
                EmptyView()
            }
        }
    }
}




//private struct SearchResultViewPreviewWrapper: View {
//    @State var tempQuery = ""
//    @State var tempSearch = false
//
//    var body: some View {
//        SearchResultView(query: $tempQuery, isSearch: $tempSearch)
//    }
//}
//
//#Preview {
//    SearchResultViewPreviewWrapper()
//}
