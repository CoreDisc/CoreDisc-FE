//
//  PostDetailMainView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/17/25.
//

import SwiftUI
import Kingfisher

enum PostCategoryTap : String, CaseIterable {
    case all = "All"
    case core = "Core"
}

struct PostMainView: View {
    @StateObject private var viewModel = PostMainViewModel()
    @StateObject private var notiViewModel = NotificationViewModel()
    
    @State private var selectedTab: PostCategoryTap = .all
    @Namespace private var animation
    @State private var searchQuery: String = ""
    @State private var isSearch: Bool = false
    
    private var selectedPosts: [PostMain] {
        switch selectedTab {
        case .all:
            return viewModel.postList
        case .core:
            return viewModel.postList.filter { $0.publicity == "CORE" }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image(.imgPostDetailMainBg)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    TitleGroup
                    
                    CategoryGroup
                    
                    PostGroup
                        .padding(.bottom, 68) // 탭바 만큼 공간 추가
                }
            }
        }
        .onAppear {
            viewModel.fetchPosts()
            notiViewModel.fetchUnRead()
        }
    }
    
    // 로고 타이틀 섹션
    private var TitleGroup: some View {
        HStack(alignment: .center, spacing: 4){
            Image(.imgLogoOneline)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 116)
                .foregroundStyle(.black)
                .padding(.leading, 6)
            
            Spacer()
            
            NavigationLink(destination: SearchView(query: $searchQuery, isSearch: $isSearch)) {
                ZStack {
                    Color.clear
                        .frame(width: 48, height: 48)
                    
                    Image(.iconSearch)
                        .resizable()
                        .frame(width:20, height: 20)
                        .foregroundStyle(.black000)
                }
            }
            
            NavigationLink(destination: NotificationView()) {
                ZStack(alignment: .topTrailing) {
                    Image(.iconAlert)
                        .resizable()
                        .frame(width:40, height: 48)
                        .foregroundStyle(.black000)
                    
                    if notiViewModel.unreadResult {
                        Circle()
                            .fill(.key)
                            .frame(width: 8)
                            .padding(.top, 10)
                            .padding(.trailing, 8)
                    }
                }
            }
        }
        .padding(.horizontal,13.5)
    }
    
    // 카테고리 메뉴바 섹션
    private var CategoryGroup: some View {
        HStack {
            PostTopTabView(selectedTab: $selectedTab, animation: animation)
        }
    }
    
    // 게시글 섹션
    private var PostGroup: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 2)
        
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(selectedPosts, id: \.postId) { item in
                    PostCard(item: item)
                        .task {
                            if item.postId == viewModel.postList.last?.postId {
                                viewModel.fetchPosts(cursor: item.postId)
                            }
                        }
                }
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 21)
    }
}

// 게시물 카드
struct PostCard: View {
    var item: PostMain
    
    var body: some View {
        NavigationLink(destination: PostDetailView(postId: item.postId)) {
            ZStack(alignment: .top) {
                Rectangle()
                    .frame(width: 164)
                    .foregroundStyle(.white)
                
                VStack(spacing: 8){
                    // 게시글 사진
                    if item.answer.answerType == "IMAGE" {
                        if let url = URL(string: item.answer.imageAnswer?.thumbnailUrl ?? "") {
                            KFImage(url)
                                .placeholder({
                                    ProgressView()
                                        .controlSize(.mini)
                                })
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 164, height: 195)
                        }
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(.white)
                                .frame(width: 164, height: 195)
                            
                            Text(item.answer.textAnswer?.content
                                .splitCharacter() ?? ""
                            )
                            .textStyle(.Post_Thumbnail_text)
                            .foregroundStyle(.black000)
                            .padding(.horizontal, 18)
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 3) {
                        // 프로필 이미지
                        if let url = URL(string: item.member.profileImg) {
                            KFImage(url)
                                .placeholder({
                                    ProgressView()
                                        .controlSize(.mini)
                                })
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                                .padding(.top, 5)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            // 질문
                            Text(item.answer.questionContent
                                .splitCharacter()
                            )
                            .textStyle(.Button_s)
                            .foregroundStyle(.black000)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading) // 두줄 이상일 때 왼쪽 정렬
                            .padding(.leading, 1)
                            .padding(.trailing, 3)
                            
                            Spacer()
                            
                            HStack {
                                // 유저 아이디
                                Text(item.member.username)
                                    .textStyle(.login_alert)
                                    .foregroundStyle(.gray800)
                                    .padding(.bottom, 1)
                                
                                Spacer()
                                
                                if item.publicity == "CORE" {
                                    Image(.iconPublicityCore)
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(.gray800)
                                } else {
                                    Image(.iconGlobe)
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(.gray800)
                                }
                            }
                        }
                        .frame(width: 124)
                    }
                    .padding(.horizontal, 6)
                    .padding(.bottom, 10)
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .compositingGroup()
        }
    }
}

// 카테고리 메뉴바 커스텀
// TODO: 메뉴바 디자인 완료시 수정 예정
struct PostTopTabView: View {
    @Binding var selectedTab: PostCategoryTap
    var animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(PostCategoryTap.allCases, id: \.self) { item in
                let isSelected = (selectedTab == item)
                
                Text(item.rawValue)
                    .textStyle(.category_bar)
                    .foregroundColor(.black000)
                    .frame(width: 55, height: 42)
                    .contentShape(Rectangle())
                    .overlay(alignment: .bottom) {
                        if isSelected {
                            Capsule()
                                .fill(Color.black000)
                                .frame(height: 4)
                                .matchedGeometryEffect(id: "tabIndicator", in: animation)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedTab = item
                        }
                    }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.white)
    }
}


#Preview {
    PostMainView()
}

