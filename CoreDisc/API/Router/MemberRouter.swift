//
//  MemberRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 7/24/25.
//

import SwiftUI
import Moya

// /api/members API 연결
enum MemberRouter {
    case patchResign // 계정 탈퇴
    case patchProfile(profilePatchData: ProfilePatchData, deviceToken: String) // 마이홈 닉네임, 아이디 변경
    case patchPassword(passwordPatchData: PasswordPatchData) // 비밀번호 변경
    case patchMyhomeUsername(newUsername: String) // 마이홈 계정 관리 아이디 변경
    case patchMyhomePassword(myhomePasswordPatchData: MyhomePasswordPatchData) // 마이홈 계정 관리 비밀번호 변경
    case patchMyhomeEmail(email: String) // 마이홈 계정 관리 이메일 변경
    
    case getMyhome // 마이홈 본인 정보 조회
    case getMyhomeTargetUsername(targetUsername: String) // 마이홈 타사용자 정보 조회
    case getMyhomePosts(cursorId: Int?, size: Int?) // 마이홈 본인 게시글 리스트 조회
    case getMyhomeQuestion(categoryId: Int, cursorCreatedAt: String?, cursorQuestionType: String?, cursorId: Int?, size: Int?) // 코어퀘스천
    case getMyhomePostsTargetUsername(targetUsername: String, cursorId: Int?, size: Int?) // 마이홈 타사용자 게시글 리스트 조회
    
    case patchProfileImage(image: Data) // 프로필 사진 변경
    case patchDefaultImage // 기본 프로필 사진으로 변경
    case getSocial // 소셜 로그인 사용자 조회
}

extension MemberRouter: APITargetType {
    private static let memberPath = "/api/members"
    private static let myhomePath = "/api/members/my-home"
    
    var path: String {
        switch self {
        case .patchResign:
            return "\(Self.memberPath)/resign"
        case .patchProfile:
            return "\(Self.memberPath)/profile"
        case .patchPassword:
            return "\(Self.memberPath)/password"
        case .patchMyhomeUsername:
            return "\(Self.myhomePath)/username"
        case .patchMyhomePassword:
            return "\(Self.myhomePath)/password"
        case .patchMyhomeEmail:
            return "\(Self.myhomePath)/email"
            
        case .getMyhome:
            return "\(Self.myhomePath)"
        case .getMyhomeTargetUsername(let targetUsername):
            return "\(Self.myhomePath)/\(targetUsername)"
        case .getMyhomePosts:
            return "\(Self.myhomePath)/posts"
        case .getMyhomeQuestion:
            return "\(Self.myhomePath)/questions"
        case .getMyhomePostsTargetUsername(let targetUsername, _, _):
            return "\(Self.myhomePath)/posts/\(targetUsername)"
            
        case .patchProfileImage:
            return "\(Self.memberPath)/profile-image"
        case .patchDefaultImage:
            return "\(Self.memberPath)/profile-image/default"
        case .getSocial:
            return "\(Self.memberPath)/me/social"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchResign, .patchProfile, .patchPassword, .patchMyhomeUsername, .patchMyhomePassword, .patchMyhomeEmail, .patchProfileImage, .patchDefaultImage:
                .patch
        case .getMyhome,.getSocial, .getMyhomeTargetUsername, .getMyhomePosts, .getMyhomeQuestion, .getMyhomePostsTargetUsername:
                .get
        }
    }
    
    var task: Task {
        switch self {
        case .patchResign:
            return .requestPlain
        case .patchProfile(let profilePatchData, let deviceToken):
            var params: [String: Any] = [:]
            if let nickname = profilePatchData.newNickname {
                params["newNickname"] = nickname
            }
            if let username = profilePatchData.newUsername {
                params["newUsername"] = username
            }
            return .requestCompositeParameters(
                bodyParameters: params,
                bodyEncoding: JSONEncoding.default,
                urlParameters: ["deviceToken": deviceToken]
            )
        case .patchPassword(let passwordPatchData):
            return .requestJSONEncodable(passwordPatchData)
        case .patchMyhomeUsername(let newUsername):
            return .requestParameters(parameters: ["newUsername": newUsername], encoding: JSONEncoding.default)
        case .patchMyhomePassword(let myhomePasswordPatchData):
            return .requestJSONEncodable(myhomePasswordPatchData)
        case .patchMyhomeEmail(let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
            
        case .getSocial:
            return .requestPlain
        case .getMyhome:
            return .requestPlain // TODO: 수정중
        case .getMyhomeTargetUsername:
            return .requestPlain // TODO: 수정중
        case .getMyhomePosts(let cursorId, let size):
            var parameters: [String: Any] = [:]
            if let cursorId = cursorId {
                parameters["cursorId"] = cursorId
            }
            if let size = size {
                parameters["size"] = size
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getMyhomeQuestion(let categoryId, let cursorCreatedAt, let cursorQuestionType, let cursorId, let size):
            var parameters: [String: Any] = [
                "categoryId": categoryId
            ]
            if let createdAt = cursorCreatedAt {
                parameters["cursorCreatedAt"] = createdAt
            }
            if let type = cursorQuestionType {
                parameters["cursorQuestionType"] = type
            }
            if let id = cursorId {
                parameters["cursorId"] = id
            }
            if let size = size {
                parameters["size"] = size
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getMyhomePostsTargetUsername(_, let cursorId, let size):
            var parameters: [String: Any] = [:]
            if let cursorId = cursorId {
                parameters["cursorId"] = cursorId
            }
            if let size = size {
                parameters["size"] = size
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
            
            
        case .patchProfileImage(let imageData):
                let formData = MultipartFormData(
                    provider: .data(imageData),
                    name: "image",
                    fileName: "profile.jpg",
                    mimeType: "image/jpeg"
                )
                return .uploadMultipart([formData])
            
        case .patchDefaultImage:
            return .requestPlain
        }
     }
    
    var headers: [String: String]? {
        switch self {
        case .patchProfile:
            if let token = TokenProvider.shared.accessToken {
                return ["accessToken": token]
            }
            return nil
        default:
            return nil
        }
    }
}
