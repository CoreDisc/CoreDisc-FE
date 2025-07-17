//
//  UserHomeView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/17/25.
//

import SwiftUI

struct UserHomeView: View {
    @Environment(\.dismiss) var dismiss
    @State var isFollow: Bool = false
    @State var isBlock: Bool = false
    @State var showBlockButton: Bool = false
    @State var showBlockModal: Bool = false
    
    // 임시
    var userName: String = "@coredisc_kr"
    
    var body: some View {
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
                
                Spacer().frame(height: 25)
                
                FollowButton
                
                Spacer()
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
                        showBlockModal.toggle()
                    }) {
                        Text("취소하기")
                    }
                } rightButton: {
                    Button(action: {}) { // TODO: block api
                        Text("차단하기")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
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
                    dismiss()
                }) {
                    Image(.iconBack)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Button(action: {
                        showBlockButton.toggle()
                    }) {
                        Image(.iconMore)
                    }
                    
                    if showBlockButton {
                        Button(action: {
                            showBlockModal.toggle()
                        }) {
                            Text("block \(userName)")
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
            Circle() // TODO: 프로필 이미지
                .frame(width: 124, height: 124)
            
            Text(userName)
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
                Text("93") // TODO: 게시글 수 반영
                    .textStyle(.Q_Main)
                    .foregroundStyle(.white)
                
                Text("disc")
                    .textStyle(.Q_Sub)
                    .foregroundStyle(.gray400)
            }
            .frame(width: 100, height: 40)
            
            // follower
            Button(action: {}) { // TODO: action
                VStack {
                    Text("1.5k")
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
            Button(action: {}) { // TODO: action
                VStack {
                    Text("738")
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
                isFollow.toggle()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isFollow ? .gray400 : .key)
                    .frame(height: 39)
                    .padding(.horizontal, 24)
                
                Text(isFollow ? "following" : "follow")
                    .textStyle(.Pick_Q_Eng)
                    .foregroundStyle(.black000)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    UserHomeView()
}
