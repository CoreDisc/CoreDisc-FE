//
//  PutAnswerResponse.swift
//  CoreDisc
//
//  Created by 신연주 on 8/16/25.
//

import Foundation

// 텍스트 요청
struct AnswerTextRequest: Codable {
    let answerType: String
    let content: String
}

// 이미지 요청

struct PutAnswerResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PutAnswerResult
}

struct PutAnswerResult: Codable {
    let answerId: Int
    let questionId: Int
    let answerType: AnswerType
    let textAnswer: TextAnswer?
    let imageAnswer: ImageAnswer?
}

struct TextAnswer: Codable {
    let content: String
}

struct ImageAnswer: Codable {
    let imageUrl: String
}
