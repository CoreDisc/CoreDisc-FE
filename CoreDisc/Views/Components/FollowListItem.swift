//
//  FollowListItem.swift
//  CoreDisc
//
//  Created by 김미주 on 7/16/25.
//

import SwiftUI

struct FollowListItem: View {
    @State var isCoreList: Bool = false
    @State var showLabel: Bool = false
    
    var nickname: String = "닉네임"
    var username: String = "user_name"
    var followType: FollowType
    
    var body: some View {
        HStack(alignment: .top) {
            Circle() // TODO: profile image
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(nickname)
                    .textStyle(.Button_s)
                    .foregroundStyle(.white)
                
                Text("@\(username)")
                    .textStyle(.Pick_Q_Eng)
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            if followType == .follower {
                VStack(spacing: 4) {
                    Button(action: {
                        isCoreList.toggle()
                        showLabel = true
                        
                        // 시간 지나면 자동으로 label 없애기
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showLabel = false
                            }
                        }
                        
                        // TODO: core +/- api
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
