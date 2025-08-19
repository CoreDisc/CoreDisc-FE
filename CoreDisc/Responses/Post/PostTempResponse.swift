//
//  PostTempResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/19/25.
//

import Foundation

struct PostTempResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PostTempResult?
}

struct PostTempResult: Decodable {
    let postIds: [Int]
}

// id로 조회
struct PostTempIdResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PostTempIdResult
}

struct PostTempIdResult: Decodable {
    let postId: Int
    let status: String
    let answers: [PostTempIdAnswer]
}

struct PostTempIdAnswer: Decodable {
    let questionOrder: Int
    let isAnswered: Bool
    
    let answerId: Int?
    let answerType: String?
    let textContent: String?
    let imageUrl: String?
    let updatedAt: String?
}
