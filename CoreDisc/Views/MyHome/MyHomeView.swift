//
//  MypageView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI
import Kingfisher

struct MyHomeView: View {
    @Environment(NavigationRouter<MyhomeRoute>.self) private var router
    
    @StateObject private var viewModel = MyHomeViewModel()
    
    @State var showFollowerSheet: Bool = false
    @State var showFollowingSheet: Bool = false
    
    @State var showMutualModal: Bool = false
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 3)
                
                TopMenuGroup
                
                ScrollView {
                    ProfileGroup
                    
                    Spacer().frame(height: 14)
                    
                    CountGroup
                    
                    Spacer().frame(height: 16)
                    
                    ButtonGroup
                    
                    Spacer().frame(height: 31)
                    
                    PostGroup
                        .padding(.bottom, 75)
                }
                .scrollIndicators(.hidden)
            }
            
            sheetView
            
            if showMutualModal {
                BackModalView(showModal: $showMutualModal, content: "Core List는 서로 팔로우 중일 때만\n설정할 수 있어요.", buttonTitle: "뒤로가기")
            }
        }
        .task {
            viewModel.fetchMyHome()
            viewModel.fetchMyPosts()
        }
        .animation(.easeInOut(duration: 0.3), value: showFollowerSheet)
        .animation(.easeInOut(duration: 0.3), value: showFollowingSheet)
        .navigationBarBackButtonHidden()
    }
    
    // 상단 메뉴
    private var TopMenuGroup: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.highlight)
                .frame(width: 28, height: 55)
            
            Spacer()
            
            
            Button(action: {
                router.push(.calendar)
            }) {
                Image(.iconCalendar)
                    .foregroundStyle(.white)
            }
            
            Button(action: {
                router.push(.setting)
            }) {
                Image(.iconSetting)
                    .foregroundStyle(.white)
            }
        }
        .offset(x: -14)
    }
    
    // 프로필 영역
    private var ProfileGroup: some View {
        VStack(spacing: 8) {
            if let url = URL(string: viewModel.profileImageURL) {
                KFImage(url)
                    .placeholder({
                        ProgressView()
                            .controlSize(.mini)
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 124, height: 124)
                    .clipShape(Circle())
            }
            
            Text("@\(viewModel.username)")
                .textStyle(.Pick_Q_Eng)
                .foregroundStyle(.gray100)
            
            Text(viewModel.nickname)
                .textStyle(.Button_s)
                .foregroundStyle(.gray100)
        }
    }
    
    // disc, followers, following
    private var CountGroup: some View {
        HStack(spacing: 0) {
            // disc
            VStack {
                Text(viewModel.postCount)
                    .textStyle(.Q_Main)
                    .foregroundStyle(.white)
                
                Text("post")
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.gray400)
            }
            .frame(width: 100, height: 40)
            
            // follower
            Button(action: {
                showFollowerSheet = true
            }) { // TODO: action
                VStack {
                    Text(viewModel.followerCount)
                        .textStyle(.Q_Main)
                        .foregroundStyle(.white)
                    
                    Text("followers")
                        .textStyle(.Q_Sub)
                        .foregroundStyle(.gray400)
                }
            }
            .frame(width: 100, height: 40)
            .buttonStyle(.plain)
            
            // following
            Button(action: {
                showFollowingSheet = true
            }) { // TODO: action
                VStack {
                    Text(viewModel.followingCount)
                        .textStyle(.Q_Main)
                        .foregroundStyle(.white)
                    
                    Text("following")
                        .textStyle(.Q_Sub)
                        .foregroundStyle(.gray400)
                }
            }
            .frame(width: 100, height: 40)
            .buttonStyle(.plain)
        }
    }
    
    // 버튼
    private var ButtonGroup: some View {
        VStack(spacing: 12) {
            Button(action: {
                router.push(.core)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.key)
                        .frame(height: 39)
                        .padding(.horizontal, 24)
                    
                    Text("My Core Questions")
                        .textStyle(.Pick_Q_Eng)
                        .foregroundStyle(.black000)
                }
            }
            .buttonStyle(.plain)
            
            Button(action: {
                router.push(.edit)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray400)
                        .frame(height: 39)
                        .padding(.horizontal, 24)
                    
                    Text("Edit Profile")
                        .textStyle(.Pick_Q_Eng)
                        .foregroundStyle(.black000)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    // 게시글
    private var PostGroup: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 3)
        
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.postList, id: \.postId) { post in
                Button(action: {
                    router.push(.post(postId: post.postId))
                }) {
                    if let url = URL(string: post.postImageThumbnailDTO?.thumbnailUrl ?? ""),
                       !url.absoluteString.isEmpty { // 이미지
                        KFImage(url)
                            .placeholder({
                                ProgressView()
                                    .controlSize(.mini)
                            })
                            .resizable()
                            .aspectRatio(3/4, contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else if let text = post.postTextThumbnailDTO?.content { // 텍스트
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray100)
                                .stroke(.gray200, lineWidth: 0.3)
                                .frame(height: 154)
                            
                            Text(text)
                                .textStyle(.Q_pick)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black000)
                                .padding(22)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .task {
                    if post.postId == viewModel.postList.last?.postId,
                       viewModel.hasNextPage {
                        viewModel.fetchMyPosts(cursorId: post.postId)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - bottom sheet
    @ViewBuilder
    private var sheetView: some View {
        if showFollowerSheet {
            FollowSheetView(showSheet: $showFollowerSheet, showMutualModal: $showMutualModal, followType: .follower, targetUsrname: "")
                .transition(.move(edge: .bottom))
        }
        
        if showFollowingSheet {
            FollowSheetView(showSheet: $showFollowingSheet, showMutualModal: .constant(false), followType: .following, targetUsrname: "")
                .transition(.move(edge: .bottom))
        }
    }
}

#Preview {
    MyHomeView()
}
