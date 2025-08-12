//
//  PostMainResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/13/25.
//

import Foundation

struct PostMainResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PostMainResult
}

struct PostMainResult: Decodable {
    let posts: [PostMain]
    let nextCursor: Int
    let hasNext: Bool
}

struct PostMain: Decodable {
    let postId: Int
    let member: PostMainMember
    let selectedDate: String
    let answers: [PostMainAnswer]
}

struct PostMainMember: Decodable {
    let memberId: Int
    let nickname: String
    let profileImg: String
}

struct PostMainAnswer: Decodable {
    let answerId: Int
    let questionContent: String
    let answerType: String
    let imageAnswer: PostImageAnswer
    let textAnswer: PostTextAnswer
}

struct PostImageAnswer: Decodable {
    let thumbnailUrl: String
}

struct PostTextAnswer: Decodable {
    let content: String
}
