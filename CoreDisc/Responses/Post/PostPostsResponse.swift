//
//  PostpostsResponse.swift
//  CoreDisc
//
//  Created by 신연주 on 8/15/25.
//

import Foundation

struct PostPostsResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PostPostsResult
}

struct PostPostsResult: Decodable {
    let postId : Int
    let memberId : Int
    let selectedDate: String
    let status: String
    let createdAt: String
}
