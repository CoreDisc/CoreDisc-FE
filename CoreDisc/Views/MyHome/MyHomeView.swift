//
//  MypageView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct MyHomeView: View {
    @State var showFollowerSheet: Bool = false
    @State var showFollowingSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.imgShortBackground2)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 3)
                    
                    TopMenuGroup
                    
                    ProfileGroup
                    
                    Spacer().frame(height: 13)
                    
                    CountGroup
                    
                    Spacer().frame(height: 16)
                    
                    ButtonGroup
                    
                    Spacer()
                }
                
                sheetView
            }
            .animation(.easeInOut(duration: 0.3), value: showFollowerSheet)
            .animation(.easeInOut(duration: 0.3), value: showFollowingSheet)
        }
    }
    
    // 상단 메뉴
    private var TopMenuGroup: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.highlight)
                .frame(width: 28, height: 55)
            
            Spacer()
            
            Button(action: {}) { // TODO: action
                Image(.iconCalendar)
                    .foregroundStyle(.white)
            }
            
            NavigationLink(destination: SettingView()) {
                Image(.iconSetting)
                    .foregroundStyle(.white)
            }
        }
        .offset(x: -14)
    }
    
    // 프로필 영역
    private var ProfileGroup: some View {
        VStack(spacing: 8) {
            Circle() // TODO: 프로필 이미지
                .frame(width: 124, height: 124)
            
            Text("@music_sama")
                .textStyle(.Pick_Q_Eng)
                .foregroundStyle(.gray100)
            
            Text("닉네임")
                .textStyle(.Button_s)
                .foregroundStyle(.gray100)
        }
    }
    
    // disc, followers, following
    private var CountGroup: some View {
        HStack(spacing: 0) {
            // disc
            VStack {
                Text("153") // TODO: 게시글 수 반영
                    .textStyle(.Q_Main)
                    .foregroundStyle(.white)
                
                Text("disc")
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.gray400)
            }
            .frame(width: 100, height: 40)
            
            // follower
            Button(action: {
                showFollowerSheet = true
            }) { // TODO: action
                VStack {
                    Text("522")
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
                    Text("921")
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
            Button(action: {}) {
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
            
            NavigationLink(destination: EditProfileView()) {
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
    
    // MARK: - bottom sheet
    @ViewBuilder
    private var sheetView: some View {
        if showFollowerSheet {
            FollowSheetView(showSheet: $showFollowerSheet, followType: .follower)
                .transition(.move(edge: .bottom))
                .zIndex(1)
        }
        
        if showFollowingSheet {
            FollowSheetView(showSheet: $showFollowingSheet, followType: .following)
                .transition(.move(edge: .bottom))
                .zIndex(1)
        }
    }
}

#Preview {
    MyHomeView()
}
