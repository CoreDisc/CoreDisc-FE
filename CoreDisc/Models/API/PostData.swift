//
//  PostData.swift
//  CoreDisc
//
//  Created by 김미주 on 7/25/25.
//

import Foundation

// 게시글 발행
struct PostPublishData: Codable {
    let publicity: String
    let selectiveDiary: SelectiveDiaryData
}

struct SelectiveDiaryData: Codable {
    let who: String
    let `where`: String
    let what: String
    let detail: String?
}

// 게시글 피드 조회 (Pull 모델)
struct PostFeedData: Codable {
    let feedType: PostFeedType
    let cursor: Int
    let size: Int
}

