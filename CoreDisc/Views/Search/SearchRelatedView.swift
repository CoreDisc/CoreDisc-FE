//
//  SearchRelatedView.swift
//  CoreDisc
//
//  Created by 이채은 on 7/23/25.
//
import SwiftUI

struct SearchRelatedView: View {
    @ObservedObject var viewModel: SearchMemberViewModel
    var keyword: String
    
    @Environment(NavigationRouter<PostRoute>.self) var router
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.gray600)
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 6)
                    
                    ForEach(viewModel.items) { user in
                        SearchProfileItem(
                            nickname: user.nickname,
                            username: "@\(user.username)",
                            imageURL: user.profileImgDTO?.imageUrl,
                            onTap: {
                                let targetUsername = user.username
                                router.push(.user(userName: targetUsername))
                            }
                        )
                        .task {
                            viewModel.loadMoreIfNeeded(current: user)
                        }
                        
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundStyle(.black000)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.vertical, 16)
                    } else if viewModel.items.isEmpty {
                        Text("검색 결과가 없습니다")
                            .textStyle(.Pick_Q_Eng)
                            .foregroundStyle(.gray200)
                            .padding(.vertical, 24)
                    }
                }
                .padding(.leading, 8)
                .padding(.trailing, 28)
            }
        }
        .padding(.horizontal, 25)
        .frame(height: 274)
        .task {
            if !keyword.isEmpty {
                viewModel.startSearch(keyword: keyword, record: false)
            }
        }
        .onChange(of: keyword) { _, newValue in
            if !newValue.isEmpty {
                viewModel.startSearch(keyword: newValue)
            } else {
                viewModel.items.removeAll()
            }
        }
    }
}
