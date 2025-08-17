//
//  UserHomeView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/17/25.
//

import SwiftUI
import Kingfisher

struct UserHomeView: View {
    @Environment(NavigationRouter<MyhomeRoute>.self) private var router
    
    @StateObject var viewModel = UserHomeViewModel()
    
    @State var showBlockButton: Bool = false
    @State var showBlockModal: Bool = false
    @State var showUnblockModal: Bool = false
    
    @State var showFollowerSheet: Bool = false
    @State var showFollowingSheet: Bool = false
    
    var userName: String
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 3)
                
                TopMenuGroup
                
                ScrollView {
                    ProfileGroup
                    
                    Spacer().frame(height: 13)
                    
                    CountGroup
                    
                    Spacer().frame(height: 25)
                    
                    FollowButton
                    
                    Spacer().frame(height: 25)
                    
                    PostGroup
                }
            }
            
            // 차단 모달
            if showBlockModal {
                ModalView {
                    VStack(spacing: 10) {
                        Text("차단하면 서로의 게시글과 활동을 볼 수 없습니다.")
                            .textStyle(.Button_s)
                        
                        Text("차단하시겠습니까?")
                            .textStyle(.Button_s)
                    }
                } leftButton: {
                    Button(action: {
                        showBlockModal.toggle() // 차단모달 제거
                        showBlockButton.toggle() // 차단버튼 제거
                    }) {
                        Text("취소하기")
                    }
                } rightButton: {
                    Button(action: {
                        viewModel.fetchBlock(targetId: viewModel.memberId) {
                            viewModel.fetchUserHome(username: userName)
                        }
                        showBlockModal.toggle() // 차단모달 제거
                        showBlockButton.toggle() // 차단버튼 제거
                    }) {
                        Text("차단하기")
                            .foregroundStyle(.red)
                    }
                }
            }
            
            // 차단 해제 모달
            if showUnblockModal {
                ModalView {
                    VStack(spacing: 10) {
                        Text("차단을 해제하면 서로의 활동을 다시 볼 수 있습니다.")
                            .textStyle(.Button_s)
                        
                        Text("차단 해제하시겠습니까?")
                            .textStyle(.Button_s)
                    }
                } leftButton: {
                    Button(action: {
                        showUnblockModal.toggle() // 차단해제모달 제거
                        showBlockButton.toggle() // 차단버튼 제거
                    }) {
                        Text("취소하기")
                    }
                } rightButton: {
                    Button(action: {
                        viewModel.fetchUnblock(targetId: viewModel.memberId) {
                            viewModel.fetchUserHome(username: userName)
                        }
                        showUnblockModal.toggle() // 차단해제모달 제거
                        showBlockButton.toggle() // 차단버튼 제거
                    }) {
                        Text("차단 해제하기")
                            .foregroundStyle(.red)
                    }
                }
            }
            
            sheetView
        }
        .task {
            viewModel.fetchUserHome(username: userName)
            viewModel.fetchUserPosts(targetUsername: userName)
        }
        .navigationBarBackButtonHidden()
        .animation(.easeInOut(duration: 0.3), value: showFollowerSheet)
        .animation(.easeInOut(duration: 0.3), value: showFollowingSheet)
    }
    
    // 상단 메뉴
    private var TopMenuGroup: some View {
        ZStack(alignment: .top) {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.highlight)
                    .frame(width: 28, height: 55)
                    .offset(x: -14)
                
                Spacer()
            }
            
            HStack(alignment: .top) {
                Button(action: {
                    router.pop()
                }) {
                    Image(.iconBack)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 0) {
                    Button(action: {
                        showBlockButton.toggle()
                    }) {
                        Image(.iconMore)
                            .foregroundStyle(.key)
                    }
                    
                    if showBlockButton {
                        Button(action: {
                            viewModel.blocked ? showUnblockModal.toggle() : showBlockModal.toggle()
                        }) {
                            Text(viewModel.blocked ? "unblock \(userName)" : "block \(userName)")
                                .textStyle(.Button_s)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(.gray800)
                                )
                        }
                    }
                }
            }
            .padding(.leading, 17)
            .padding(.trailing, 21)
        }
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
                    .aspectRatio(contentMode: .fit)
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
    
    // 팔로우 버튼
    private var FollowButton: some View {
        Button(action: {
            withAnimation(nil) {
                if viewModel.isFollowing {
                    viewModel.fetchUnfollow(targetId: viewModel.memberId) {
                        viewModel.fetchUserHome(username: userName)
                    }
                } else {
                    viewModel.fetchFollow(targetId: viewModel.memberId) {
                        viewModel.fetchUserHome(username: userName)
                    }
                }
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(viewModel.blocked ? .clear : viewModel.isFollowing ? .gray400 : .key)
                    .stroke(viewModel.blocked ? .warning : .clear, lineWidth: 1)
                    .frame(height: 39)
                    .padding(.horizontal, 24)
                
                Text(viewModel.blocked ? "blocked" : viewModel.isFollowing ? "following" : "follow")
                    .textStyle(.Q_Sub)
                    .foregroundStyle(viewModel.blocked ? .warning : .black000)
            }
        }
        .buttonStyle(.plain)
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
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 154)
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
            }
        }
        .padding(.horizontal, 15)
    }
    
    // MARK: - bottom sheet
    @ViewBuilder
    private var sheetView: some View {
        if showFollowerSheet {
            FollowSheetView(showSheet: $showFollowerSheet, showMutualModal: .constant(false), followType: .userFollower, targetUsrname: userName)
                .transition(.move(edge: .bottom))
                .zIndex(1)
        }
        
        if showFollowingSheet {
            FollowSheetView(showSheet: $showFollowingSheet, showMutualModal: .constant(false), followType: .userFollowing, targetUsrname: userName)
                .transition(.move(edge: .bottom))
                .zIndex(1)
        }
    }
}

#Preview {
    UserHomeView(userName: "")
}
