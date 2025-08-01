//
//  UserHomeResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/1/25.
//

import Foundation

struct UserHomeResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UserHomeResult
}

struct UserHomeResult: Decodable {
    let memberId: Int
    let username: String
    let nickname: String
    let followerCount: String
    let followingCount: String
    let postCount: String
    let isFollowing: Bool
    let profileImgDTO: UserProfileImgDTO
    let blocked: Bool
}

struct UserProfileImgDTO: Decodable {
    let profileImgId: Int
    let imageUrl: String
}
