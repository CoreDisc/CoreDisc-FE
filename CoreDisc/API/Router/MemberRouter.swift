//
//  MemberRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 7/24/25.
//

import Foundation
import Moya

// /api/members API 연결
enum MemberRouter {
    case patchResign // 계정 탈퇴
    case patchProfile(profilePatchData: ProfilePatchData) // 마이홈 닉네임, 아이디 변경
    case patchPassword(passwordPatchData: PasswordPatchData) // 비밀번호 변경
    case patchMyhomeUsername(newUsername: String) // 마이홈 계정 관리 아이디 변경
    case patchMyhomePassword(myhomePasswordPatchData: MyhomePasswordPatchData) // 마이홈 계정 관리 비밀번호 변경
    case patchMyhomeEmail(email: String) // 마이홈 계정 관리 이메일 변경
    
    case getMyhome // 마이홈 본인 정보 조회
    case getMyhomeTargetUsername(targetUsername: String) // 마이홈 타사용자 정보 조회
    case getMyhomePosts // 마이홈 본인 게시글 리스트 조회
    case getMyhomePostsTargetUsername(targetUsername: String) // 마이홈 타사용자 게시글 리스트 조회
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
        case .getMyhomePostsTargetUsername(let targetUsername):
            return "\(Self.myhomePath)/posts/\(targetUsername)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchResign, .patchProfile, .patchPassword, .patchMyhomeUsername, .patchMyhomePassword, .patchMyhomeEmail:
                .patch
        case .getMyhome, .getMyhomeTargetUsername, .getMyhomePosts, .getMyhomePostsTargetUsername:
                .get
        }
    }
    
    var task: Task {
        switch self {
        case .patchResign:
            return .requestPlain
        case .patchProfile(let profilePatchData):
            return .requestJSONEncodable(profilePatchData)
        case .patchPassword(let passwordPatchData):
            return .requestJSONEncodable(passwordPatchData)
        case .patchMyhomeUsername(let newUsername):
            return .requestParameters(parameters: ["newUsername": newUsername], encoding: URLEncoding.queryString)
        case .patchMyhomePassword(let myhomePasswordPatchData):
            return .requestJSONEncodable(myhomePasswordPatchData)
        case .patchMyhomeEmail(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
        
        case .getMyhome:
            return .requestPlain // TODO: 수정중
        case .getMyhomeTargetUsername:
            return .requestPlain // TODO: 수정중
        case .getMyhomePosts:
            return .requestPlain // TODO: 수정중
        case .getMyhomePostsTargetUsername:
            return .requestPlain  // TODO: 수정중
        }
    }
}
