//
//  BlockResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/5/25.
//

import Foundation

// MARK: - 차단
struct BlockResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: BlockResult
}

struct BlockResult: Decodable {
    let id: Int
    let blockerId: Int
    let blockedId: Int
    let profileImgDTO: BlockProfileImgDTO
    let createdAt: String
}

struct BlockProfileImgDTO: Decodable {
    let profileImgId: Int
    let imageUrl: String
}

// MARK: - 차단 취소
struct UnblockResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

// MARK: - 차단 목록
struct BlockListResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: BlockListResult
}

struct BlockListResult: Decodable {
    let values: [BlockListValue]
    let hasNext: Bool
}

struct BlockListValue: Decodable {
    let blockedId: Int
    let blockedNickname: String
    let blockedUsername: String
    let profileImgDTO: BlockProfileImgDTO
}
