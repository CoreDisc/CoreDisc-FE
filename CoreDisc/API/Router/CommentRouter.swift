//
//  CommentRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 8/14/25.
//

import Foundation
import Moya

// 댓글 API 연결
enum CommentRouter {
    case getComments(postId: Int, cursorId: Int?, size: Int?) // 댓글 목록 조회
    case postComments(postId: Int, content: String) // 댓글 작성
    case getReplies(commentId: Int, cursorId: Int?, size: Int?) // 대댓글 목록 조회
    case postReplies(commentId: Int, content: String) // 대댓글 작성
    case deleteComment(commentId: Int) // 댓글 삭제
}

extension CommentRouter: APITargetType {
    private static let postPath = "/posts"
    private static let commentPath = "/comments"
    
    var path: String {
        switch self {
        case .getComments(let postId, _, _), .postComments(let postId, _):
            return "\(Self.postPath)/\(postId)/comments"
        case .getReplies(let commentId, _, _), .postReplies(let commentId, _):
            return "\(Self.commentPath)/\(commentId)/replies"
        case .deleteComment(let commentId):
            return "\(Self.commentPath)/\(commentId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getComments, .getReplies:
            return .get
        case .postComments, .postReplies:
            return .post
        case .deleteComment:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getComments(_, let cursorId, let size):
            var parameters: [String: Any] = [:]
            if let cursorId = cursorId {
                parameters["cursorId"] = cursorId
            }
            if let size = size {
                parameters["size"] = size
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .postComments(_, let content):
            return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
        case .getReplies(_, let cursorId, let size):
            var parameters: [String: Any] = [:]
            if let cursorId = cursorId {
                parameters["cursorId"] = cursorId
            }
            if let size = size {
                parameters["size"] = size
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .postReplies(_, let content):
            return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
        case .deleteComment:
            return .requestPlain
        }
    }
}
