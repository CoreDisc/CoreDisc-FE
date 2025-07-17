//
//  FollowListItem.swift
//  CoreDisc
//
//  Created by 김미주 on 7/16/25.
//

import SwiftUI

struct FollowListItem: View {
    var nickname: String = "닉네임"
    var username: String = "user_name"
    
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
            
            Button(action: {}) { // TODO: core +/-
                Image(.iconCore)
                    .foregroundStyle(.gray400)
            }
        }
    }
}

#Preview {
    FollowListItem()
}
