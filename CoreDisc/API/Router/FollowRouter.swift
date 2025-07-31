//
//  FollowRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 7/26/25.
//

import Foundation
import Moya

// 팔로우 관련 API 연결
enum FollowRouter {
    case postFollow(targetId: Int) // 팔로우
    case getFollowings // 팔로잉 목록 조회
    case getFollowers(cursorId: Int?, size: Int?) // 팔로워 목록 조회
    case deleteFollowings(targetId: Int) // 팔로우 취소
}

extension FollowRouter: APITargetType {
    var path: String {
        switch self {
        case .postFollow(let targetId):
            return "/api/follow/\(targetId)"
        case .getFollowings:
            return "/api/followings"
        case .getFollowers:
            return "/api/followers"
        case .deleteFollowings(let targetId):
            return "/api/followings/\(targetId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postFollow:
            return .post
        case .getFollowers, .getFollowings:
            return .get
        case .deleteFollowings:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .postFollow, .getFollowers, .getFollowings, .deleteFollowings:
            return .requestPlain
        }
    }
}
