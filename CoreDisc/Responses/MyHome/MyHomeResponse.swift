//
//  MyHomeResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 7/27/25.
//

import Foundation

struct MyHomeResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MyHomeResult
}

struct MyHomeResult: Decodable {
    let memberId: Int
    let username: String
    let nickname: String
    let followerCount: String
    let followingCount: String
    let postCount: String
    let profileImgDTO: ProfileImgDTO
}

struct ProfileImgDTO: Decodable {
    let profileImgId: Int
    let imageUrl: String
}

struct ProfileResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String?
}

struct ImageResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ImageResult?
}

struct ImageResult: Decodable {
    let profileImgId: Int
    let imageUrl: String
}
