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
    case putAnswerText(postId: Int, questionOrder: Int, content: String) // 글 답변 작성/수정
    case putAnswerImage(postId: Int, questionOrder: Int, image: Data) // 이미지 답변 등록 또는 수정
    
    case getPosts(feedType: String?, cursorId: Int?, size: Int?) // 게시글 피드 조회 (Pull 모델)
    case postPosts(selectedDate: String) // 게시글 생성 (임시저장)
    case postLikes(postId: Int) // 좋아요 추가
    case deleteLikes(postId: Int) // 좋아요 제거
    case getPostsDetail(postId: Int) // 게시글 상세 조회
    case deletePosts(postId: Int) // 게시글 삭제
    
    case getTemp // 게시글 조회
    case getTempID(postId: Int) // 임시저장 게시글 ID로 조회
}

extension PostRouter: APITargetType {
    private static let postPath = "/api/posts"
    
    var path: String {
        switch self {
        case .putPublish(let postId, _):
            return "\(Self.postPath)/\(postId)/publish"
        case .putAnswerText(let postId, let questionOrder, _):
            return "\(Self.postPath)/\(postId)/answers/\(questionOrder)/text"
        case .putAnswerImage(let postId, let questionOrder, _):
            return "\(Self.postPath)/\(postId)/answers/\(questionOrder)/image"
            
        case .getPosts:
            return "\(Self.postPath)"
        case .postPosts:
            return "\(Self.postPath)"
        case .postLikes(let postId):
            return "\(Self.postPath)/\(postId)/likes"
        case .deleteLikes(let postId):
            return "\(Self.postPath)/\(postId)/likes"
        case .getPostsDetail(let postId):
            return "\(Self.postPath)/\(postId)"
        case .deletePosts(let postId):
            return "\(Self.postPath)/\(postId)"
        
        case .getTemp:
            return "\(Self.postPath)/temp"
        case .getTempID(let postId):
            return "\(Self.postPath)/temp/\(postId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .putPublish, .putAnswerText, .putAnswerImage:
            return .put
        case .getPosts, .getPostsDetail, .getTemp, .getTempID:
            return .get
        case .postPosts, .postLikes:
            return .post
        case .deletePosts, .deleteLikes:
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
            var parts: [MultipartFormData] = []
            parts.append(
                MultipartFormData(
                    provider: .data(image),
                    name: "image",
                    fileName: "answer.jpg",
                    mimeType: "image/jpeg"
                )
            )
            return .uploadMultipart(parts)
            
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
        case .postLikes:
            return .requestPlain
        case .deleteLikes:
            return .requestPlain
        case .getPostsDetail:
            return .requestPlain
        case .deletePosts:
            return .requestPlain
            
        case .getTemp:
            return .requestPlain
        case .getTempID:
            return .requestPlain
        }
    }
}
