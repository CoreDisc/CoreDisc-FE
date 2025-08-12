//
//  PostRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 7/25/25.
//

import Foundation
import Moya

// /api/posts API 연결
enum PostRouter {
    case putPublish(postId: Int, postPublishData: PostPublishData) // 게시글 발행
    case putAnswerText(postId: Int, questionId: Int, content: String) // 글 답변 작성/수정
    case putAnswerImage(postId: Int, questionId: Int, image: String) // 이미지 답변 등록 또는 수정
    
    case getPosts(feedType: String?, cursorId: Int?, size: Int?) // 게시글 피드 조회 (Pull 모델)
    case postPosts(selectedDate: String) // 게시글 생성 (임시저장)
    case getPostsDetail(postId: Int) // 게시글 상세 조회
    case deletePosts(postId: Int) // 게시글 삭제
    
    case getTempID(postId: Int) // 임시저장 게시글 ID로 조회
    case getTempDate(selectedDate: String) // 임시저장 게시글 날짜로 조회
    case deleteAnswers(postId: Int, questionId: Int) // 답변 삭제
}

extension PostRouter: APITargetType {
    private static let postPath = "/api/posts"
    
    var path: String {
        switch self {
        case .putPublish(let postId, _):
            return "\(Self.postPath)/\(postId)/publish"
        case .putAnswerText(let postId, let questionId, _):
            return "\(Self.postPath)/\(postId)/answers/\(questionId)/text"
        case .putAnswerImage(let postId, let questionId, _):
            return "\(Self.postPath)/\(postId)/answers/\(questionId)/image"
            
        case .getPosts:
            return "\(Self.postPath)"
        case .postPosts:
            return "\(Self.postPath)"
        case .getPostsDetail(let postId):
            return "\(Self.postPath)/\(postId)"
        case .deletePosts(let postId):
            return "\(Self.postPath)/\(postId)"
        
        case .getTempID(let postId):
            return "\(Self.postPath)/temp/\(postId)"
        case .getTempDate:
            return "\(Self.postPath)/posts/temp"
        case .deleteAnswers(let postId, let questionId):
            return "\(Self.postPath)/\(postId)/answers/\(questionId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .putPublish, .putAnswerText, .putAnswerImage:
            return .put
        case .getPosts, .getPostsDetail, .getTempID, .getTempDate:
            return .get
        case .postPosts:
            return .post
        case .deletePosts, .deleteAnswers:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .putPublish(_, let postPublishData):
            return .requestJSONEncodable(postPublishData)
        case .putAnswerText(_, _, let content):
            return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
        case .putAnswerImage(_, _, let image):
            return .requestParameters(parameters: ["image": image], encoding: JSONEncoding.default)
            
        case .getPosts(
            let feedType,
            let cursor,
            let size
        ):
            var parameters: [String: Any] = [:]
            if let feedType = feedType {
                parameters["feedType"] = feedType
            }
            if let cursor = cursor {
                parameters["cursor"] = cursor
            }
            if let size = size {
                parameters["size"] = size
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .postPosts(let selectedDate):
            return .requestParameters(parameters: ["selectedDate": selectedDate], encoding: JSONEncoding.default)
        case .getPostsDetail:
            return .requestPlain
        case .deletePosts:
            return .requestPlain
            
        case .getTempID:
            return .requestPlain
        case .getTempDate(let selectedDate):
            return .requestParameters(parameters: ["selectedDate": selectedDate], encoding: JSONEncoding.default)
        case .deleteAnswers:
            return .requestPlain
        }
    }
}
