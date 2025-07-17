//
//  FollwersSheetView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/16/25.
//

import SwiftUI

enum FollowType: String {
    case follower = "followers"
    case following = "followings"
}

struct FollowSheetView: View {
    @Binding var showSheet: Bool
    @State private var viewModel = FollowSheetViewModel()
    var followType: FollowType
    
    // 유저 수 (임시)
    var coreCount: Int = 82
    var followerCount: Int = 522
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray600)
                .shadow(color: .black000, radius: 5, x: 0, y: 0)
            
            VStack(spacing: 0) {
                TopGroup
                
                Spacer().frame(height: 30)
                
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
    }
    
    // 상단바
    private var TopGroup: some View {
        ZStack() {
            Text(followType.rawValue)
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
                Text("\(followerCount)")
                    .textStyle(.Q_Main)
                    .foregroundStyle(.white)
                
                Text(followType.rawValue)
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.gray400)
            }
            
            Spacer()
            
            CorelistToggle()
        }
        .padding(.top, 12)
        .padding(.horizontal, 3)
        .padding(.bottom, 24)
    }
    
    // 리스트
    private var FollowerList: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                ForEach(viewModel.followerSample, id: \.id) { item in
                    FollowListItem(nickname: item.nickname, username: item.username)
                }
            }
            .padding(.bottom, 80)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 3)
    }
}

#Preview {
    FollowSheetView(showSheet: .constant(true), followType: .follower)
}
