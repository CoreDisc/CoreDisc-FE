//
//  PostDiaryResponse.swift
//  CoreDisc
//
//  Created by 신연주 on 8/15/25.
//

import Foundation

struct PostDiaryResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PostDiaryResult
}

struct PostDiaryResult: Decodable {
    let postId: Int?
    let status: String
    let publishedAt: String
}
