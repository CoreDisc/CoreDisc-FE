//
//  PostData.swift
//  CoreDisc
//
//  Created by 김미주 on 7/25/25.
//

import Foundation

enum PostPublicityType: String, Codable {
    case OFFICIAL = "OFFICIAL"
    case PERSONAL = "PERSONAL"
    case CIRCLE = "CIRCLE"
}

enum PostFeedType: String, Codable {
    case ALL = "ALL"
    case CORE = "CORE"
}

// 게시글 발행
struct PostPublishData: Codable {
    let postId: Int?
    let publicity: PostPublicityType
    let selectiveDiary: [SelectiveDiaryData]
}

struct SelectiveDiaryData: Codable {
    let who: String
    let `where`: String
    let what: String
    let detail: String
}
