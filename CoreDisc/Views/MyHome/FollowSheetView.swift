//
//  FollwersSheetView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/16/25.
//

import SwiftUI
import Kingfisher

struct FollowSheetView: View {
    @Binding var showSheet: Bool
    @StateObject private var viewModel = FollowSheetViewModel()
    
    @State private var currentFollowType: FollowType = .follower
    
    var followType: FollowType
    var targetUsrname: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray600)
                .shadow(color: .black000, radius: 5, x: 0, y: 0)
            
            VStack(spacing: 22) {
                TopGroup
                
                SecondGroup
                
                FollowerList
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 14)
        }
        .padding(.top, 120)
        .padding(.horizontal, 18)
        .ignoresSafeArea()
        .task {
            currentFollowType = followType
            viewModel.currentTargetUsername = targetUsrname
            
            switch followType {
            case .follower:
                viewModel.fetchFollowers()
            case .following:
                viewModel.fetchFollowings()
            case .userFollower:
                viewModel.fetchUserFollowers(targetUsername: targetUsrname)
            case .userFollowing:
                viewModel.fetchUserFollowings(targetUsername: targetUsrname)
            case .coreList:
                viewModel.fetchCircleList()
            }
        }
    }
    
    // 상단바
    private var TopGroup: some View {
        ZStack() {
            Text(currentFollowType.title)
                .textStyle(.Pick_Q_Eng)
                .foregroundStyle(.white)
            
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showSheet = false
                    }
                }) {
                    Image(.iconClose)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray200)
                }
            }
        }
    }
    
    // 유저 수 & 토글
    private var SecondGroup: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(viewModel.getCount(for: currentFollowType))")
                    .textStyle(.Q_Main)
                    .foregroundStyle(.white)
                
                Text(currentFollowType.title)
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.gray400)
            }
            
            Spacer()
            
            if followType == .follower || currentFollowType == .coreList {
                CorelistToggle(currentFollowType: $currentFollowType, viewModel: viewModel)
            }
        }
        .padding(.horizontal, 3)
    }
    
    // 리스트
    private var FollowerList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                let list = viewModel.getDisplayList(for: currentFollowType)
                ForEach(list, id: \.id) { item in
                    NavigationLink(destination: UserHomeView(userName: item.username)) {
                        FollowListItem(
                            item: item,
                            followType: currentFollowType,
                            isCoreList: item.isCore,
                            viewModel: viewModel
                        )
                            .task {
                                if item.id == list.last?.id,
                                   viewModel.hasNextPage(for: currentFollowType) {
                                    viewModel.fetchMore(for: currentFollowType, cursorId: item.id)
                                }
                            }
                    }
                }
            }
            .padding(.bottom, 80)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 3)
    }
}

// MARK: - components
// 리스트 아이템
struct FollowListItem: View {
    let item: FollowDisplayModel
    var followType: FollowType
    
    @State var isCoreList: Bool
    @State var showLabel: Bool = false
    
    @ObservedObject var viewModel: FollowSheetViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            if let imageUrl = item.profileImgUrl,
               let url = URL(string: imageUrl) {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(.gray400)
                    .frame(width: 32, height: 32)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(item.nickname)
                    .textStyle(.Button_s)
                    .foregroundStyle(.white)
                
                Text("@\(item.username)")
                    .textStyle(.Pick_Q_Eng)
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            if followType == .follower || followType == .coreList {
                VStack(spacing: 4) {
                    Button(action: {
                        viewModel.fetchCircle(targetId: item.id, isCircle: !isCoreList) {
                            isCoreList.toggle()
                            showLabel = true
                            
                            // 시간 지나면 자동으로 label 없애기
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    showLabel = false
                                }
                            }
                        }
                    }) {
                        Image(.iconCore)
                            .foregroundStyle(isCoreList ? .key : .gray400)
                    }
                    .buttonStyle(.plain)
                    
                    Text(isCoreList ? "+ CORE list" : "- CORE list")
                        .textStyle(.Post_UserID)
                        .foregroundStyle(.black000)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.gray400)
                        )
                        .opacity(showLabel ? 1 : 0)
                        .animation(.easeInOut, value: showLabel)
                }
            }
        }
    }
}

// 코어리스트 토글
struct CorelistToggle: View {
    @Binding var currentFollowType: FollowType
    @State private var isCorelist: Bool = false
    
    @ObservedObject var viewModel: FollowSheetViewModel
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                if isCorelist {
                    currentFollowType = .follower
                    viewModel.fetchCircleList()
                } else {
                    currentFollowType = .coreList
                    viewModel.fetchCircleList()
                }
                isCorelist.toggle()
            }
        }) {
            ZStack(alignment: isCorelist ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.gray800)
                    .frame(width: 60, height: 32)
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(isCorelist ? .black000 : .gray600)
                    .frame(width: 56, height: 28)
                    .padding(.horizontal, 2)
                
                Image(.iconCore)
                    .foregroundStyle(isCorelist ? .key : .gray400)
                    .padding(.horizontal, 4)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FollowSheetView(showSheet: .constant(true), followType: .following, targetUsrname: "")
}
