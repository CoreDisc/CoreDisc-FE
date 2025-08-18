//
//  FollowType.swift
//  CoreDisc
//
//  Created by 김미주 on 8/16/25.
//

import Foundation

enum FollowType {
    case follower, userFollower, coreList, following, userFollowing
    
    var title: String {
        switch self {
        case .follower, .userFollower, .coreList: 
            return "followers"
        case .following, .userFollowing:
            return "followings"
        }
    }
}
