//
//  AuthRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 7/23/25.
//

import Foundation
import Moya

// /api/auth API 연결
enum AuthRouter {
    case postVerifyCode(verifyCodeData: VerifyCodeData) // 이메일 코드 인증
    case postUsername(usernameData: UsernameData) // 아이디 찾기
    case postSignup(signupData: SignupData) // 회원가입
    case postSendCode(email: String) // 이메일 인증 메일 전송
    case postReissue // 토큰 재발급
    case postVerifyUser(verifyUserData: VerifyUserData) // 비밀번호 변경을 위한 사용자 검증
    case postLogout // 로그아웃
    case postLogin(loginData: LoginData) // 일반 로그인
    
    case getCheckUsername(username: String) // 아이디 중복 확인
    case getCheckNickname(nickname: String) // 닉네임 중복 확인
    case getCheckEmail(email: String) // 이메일 중복 확인
}

extension AuthRouter: APITargetType {
    private static let authPath = "/api/auth"
    
    var path: String {
        switch self {
        case .postVerifyCode:
            return "\(Self.authPath)/verify-code"
        case .postUsername:
            return "\(Self.authPath)/username"
        case .postSignup:
            return "\(Self.authPath)/signup"
        case .postSendCode:
            return "\(Self.authPath)/send-code"
        case .postReissue:
            return "\(Self.authPath)/reissue"
        case .postVerifyUser:
            return "\(Self.authPath)/verify-user"
        case .postLogout:
            return "\(Self.authPath)/logout"
        case .postLogin:
            return "\(Self.authPath)/login"
            
        case .getCheckUsername:
            return "\(Self.authPath)/check-username"
        case .getCheckNickname:
            return "\(Self.authPath)/check-nickname"
        case .getCheckEmail:
            return "\(Self.authPath)/check-email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postVerifyCode, .postUsername, .postSignup, .postSendCode, .postReissue, .postVerifyUser, .postLogout, .postLogin:
            return .post
        case .getCheckUsername, .getCheckNickname, .getCheckEmail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .postVerifyCode(let verifyCodeData):
            return .requestJSONEncodable(verifyCodeData)
        case .postUsername(let usernameData):
            return .requestJSONEncodable(usernameData)
        case .postSignup(let signupData):
            return .requestJSONEncodable(signupData)
        case .postSendCode(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.default)
        case .postVerifyUser(let verifyUserData):
            return .requestJSONEncodable(verifyUserData)
        case .postReissue:
            return .requestPlain
        case .postLogout:
            return .requestPlain
        case .postLogin(let loginData):
            return .requestJSONEncodable(loginData)
            
        case .getCheckUsername(let username):
            return .requestParameters(parameters: ["username": username], encoding: URLEncoding.queryString)
        case .getCheckNickname(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        case .getCheckEmail(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
        }
    }
}
