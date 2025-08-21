//
//  PutAnswerResponse.swift
//  CoreDisc
//
//  Created by 신연주 on 8/16/25.
//

import Foundation

// 이미지 요청
struct PutAnswerResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PutAnswerResult
}

struct PutAnswerResult: Codable {
    let answerId: Int
    let questionOrder: Int
    let answerType: String
    let imageAnswer: ImageAnswer?
    let textAnswer: TextAnswer?
}

struct TextAnswer: Codable {
    let content: String
}

struct ImageAnswer: Codable {
    let imageUrl: String
    let thumbnailUrl: String
    let originalFileName: String
}
