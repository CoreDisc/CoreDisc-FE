//
//  CommentResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/14/25.
//

import Foundation

struct Comment: Decodable {
    let commentId: Int
    let postId: Int
    let content: String
    let parentId: Int?
    let depth: Int
    let member: PostMainMember
    var hasReplies: Bool
    let timeStamp: String?
    var replyCount: Int?
}

// 댓글 조회
struct CommentListResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: CommentListResult
}

struct CommentListResult: Decodable {
    let values: [Comment]
    let hasNext: Bool
}

// 댓글 작성
struct CommentWriteResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: Comment
}

// 댓글 삭제
struct CommentDeleteResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}
