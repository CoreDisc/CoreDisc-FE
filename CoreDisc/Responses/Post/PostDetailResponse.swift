//
//  PostDetailResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/13/25.
//

import Foundation

struct PostDetailResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PostDetailResult
}

struct PostDetailResult: Decodable {
    let postId: Int
    let member: PostMainMember
    let selectedDate: String
    let publicity: String
    let answers: [PostDetailAnswer]
    let selectiveDiary: PostSelectiveDiary
    let isLiked: Bool
    let isOwner: Bool
    let createdAt: String
    let updatedAt: String?
}

struct PostDetailAnswer: Decodable {
    let answerId: Int
    let questionContent: String
    let answerType: String
    let imageAnswer: PostImageAnswer?
    let textAnswer: PostTextAnswer?
}

struct PostSelectiveDiary: Decodable {
    let who: DiaryWho
    let `where`: DiaryWhere
    let what: DiaryWhat
    let mood: String
}
