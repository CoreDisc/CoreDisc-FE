//
//  FollowersResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/1/25.
//

import Foundation

// MARK: - Follower
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
    let isCircle: Bool
    let isMutual: Bool?
}

struct FollowerProfileImgDTO: Decodable {
    let profileImgId: Int
    let imageUrl: String
}

// MARK: - UserFollower
struct UserFollowersResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UserFollowersResult
}

struct UserFollowersResult: Decodable {
    let totalCount: Int
    let followerCursor: UserFollowerCursor
}

struct UserFollowerCursor: Decodable {
    let values: [UserFollowerValues]
    let hasNext: Bool
}

struct UserFollowerValues: Decodable {
    let followerId: Int
    let nickname: String
    let username: String
    let profileImgDTO: FollowerProfileImgDTO?
}

struct UserFollowerProfileImgDTO: Decodable {
    let profileImgId: Int
    let imageUrl: String
}

// MARK: - Following
struct FollowingsResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: FollowingsResult
}

struct FollowingsResult: Decodable {
    let totalCount: Int
    let followingCursor: FollowingCursor
}

struct FollowingCursor: Decodable {
    let values: [FollowingValues]
    let hasNext: Bool
}

struct FollowingValues: Decodable {
    let followingId: Int
    let nickname: String
    let username: String
    let profileImgDTO: FollowingProfileImgDTO?
}

struct FollowingProfileImgDTO: Decodable {
    let profileImgId: Int
    let imageUrl: String
}

// MARK: - 팔로우하기
struct FollowResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: FollowResult
}

struct FollowResult: Decodable {
    let id: Int
    let followerId: Int
    let followingId: Int
    let createdAt: String
}

// MARK: - 언팔로우하기
struct UnfollowResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

// MARK: - Common
struct FollowDisplayModel: Identifiable {
    let id: Int
    let nickname: String
    let username: String
    let profileImgUrl: String?
    let isCore: Bool
}
