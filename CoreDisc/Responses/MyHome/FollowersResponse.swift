//
//  FollowersResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/1/25.
//

import Foundation

struct FollowersResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: FollowersResult
}

struct FollowersResult: Decodable {
    let totalCount: Int
    let followerCursor: FollowerCursor
}

struct FollowerCursor: Decodable {
    let values: [FollowerValues]
    let hasNext: Bool
}

struct FollowerValues: Decodable {
    let followerId: Int
    let nickname: String
    let username: String
    let profileImgDTO: FollowerProfileImgDTO?
    let isMutual: Bool
    let circle: Bool
}

struct FollowerProfileImgDTO: Decodable {
    let profileImgId: Int
    let imageUrl: String
}
