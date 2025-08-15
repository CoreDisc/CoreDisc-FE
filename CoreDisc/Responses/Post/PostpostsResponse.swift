//
//  PostpostsResponse.swift
//  CoreDisc
//
//  Created by 신연주 on 8/15/25.
//

import Foundation

struct PostpostsResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PostpostsResult
}

struct PostpostsResult: Decodable {
    let postId : Int
    let memberId : Int
    let selectedDate: String
    let status: String
    let todayQuestions: [TodayQuestion]
    let createdAt: String
}

struct TodayQuestion: Decodable {
    let id : Int
    let type: Int
    let questionId: Int
    let questionType: String
    let content: String
}
