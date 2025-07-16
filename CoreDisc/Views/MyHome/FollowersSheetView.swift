//
//  FollwersSheetView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/16/25.
//

import SwiftUI

struct FollowersSheetView: View {
    @Binding var showSheet: Bool
    @State private var viewModel = FollowersSheetViewModel()
    
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
                
                Spacer().frame(height: 29)
                
                CORElist
                
                Divider()
                    .background(.highlight)
                    .frame(height: 0.4)
                
                FollowerCount
                
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
            Text("followers")
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
    
    // 코어리스트
    private var CORElist: some View {
        VStack {
            HStack(spacing: 13) {
                Text("CORE list")
                    .textStyle(.Pick_Q_Eng)
                    .foregroundStyle(.white)
                
                Text("(\(coreCount))")
                    .textStyle(.Sub_Text_Ko)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button(action: {}) {
                    Image(.iconArrow)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(.highlight)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 4)
        }
        .padding(.vertical, 18)
    }
    
    // 유저 수
    private var FollowerCount: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(followerCount)")
                    .textStyle(.Q_Main)
                    .foregroundStyle(.white)
                
                Text("followers")
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.gray400)
            }
            
            Spacer()
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
    FollowersSheetView(showSheet: .constant(true))
}
