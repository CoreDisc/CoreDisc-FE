//
//  PostLikeResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/14/25.
//

import Foundation

struct PostLikeResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PostLikeResult
}

struct PostLikeResult: Decodable {
    let postId: Int
    let liked: Bool
}
