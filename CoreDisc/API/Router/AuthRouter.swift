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
    case postUsername(usernameData: UsernameData) // 아이디 찾기
    case postKakao(accessToken: String) // 카카오 소셜 로그인
    case postSignup(signupData: SignupData) // 회원가입
    case postVerifyCode(verifyCodeData: VerifySignupCodeData) // 회원가입 이메일 코드 인증
    case postSendCode(email: String) // 이메일 인증 메일 전송
    case postPasswordVerifyCode(verifyCodeData: VerifyCodeData) // 비밀번호 변경 이메일 코드 인증
    case postReissue // 토큰 재발급
    case postPasswordVerifyUser(verifyUserData: VerifyUserData) // 비밀번호 변경을 위한 사용자 검증
    case postLogout // 로그아웃
    case postLogin(loginData: LoginData) // 일반 로그인
    
    case getCheckUsername(username: String) // 아이디 중복 확인
    case getCheckNickname(nickname: String) // 닉네임 중복 확인
    case getCheckEmail(email: String) // 이메일 중복 확인
    
    // term
    case getTerms // 이용 약관 리스트 조회
}

extension AuthRouter: APITargetType {
    private static let authPath = "/api/auth"
    
    var path: String {
        switch self {
        case .postUsername:
            return "\(Self.authPath)/username"
        case .postKakao:
            return "\(Self.authPath)/social/kakao"
        case .postSignup:
            return "\(Self.authPath)/signup"
        case .postVerifyCode:
            return "\(Self.authPath)/signup/verify-code"
        case .postSendCode:
            return "\(Self.authPath)/send-code"
        case .postPasswordVerifyCode:
            return "\(Self.authPath)/reset-password/verify-code"
        case .postReissue:
            return "\(Self.authPath)/reissue"
        case .postPasswordVerifyUser:
            return "\(Self.authPath)/password-reset/verify-user"
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
            
        case .getTerms:
            return "/api/terms"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postUsername, .postKakao, .postSignup, .postVerifyCode, .postSendCode, .postPasswordVerifyCode, .postReissue, .postPasswordVerifyUser, .postLogout, .postLogin:
            return .post
        case .getCheckUsername, .getCheckNickname, .getCheckEmail, .getTerms:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .postUsername(let usernameData):
            return .requestJSONEncodable(usernameData)
        case .postKakao(let accessToken):
            return .requestParameters(parameters: ["accessToken": accessToken], encoding: JSONEncoding.default)
        case .postSignup(let signupData):
            return .requestJSONEncodable(signupData)
        case .postVerifyCode(let verifySignupCodeData):
            return .requestJSONEncodable(verifySignupCodeData)
        case .postSendCode(let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        case .postPasswordVerifyCode(let verifyCodeData):
            return .requestJSONEncodable(verifyCodeData)
        case .postReissue: // TODO: 수정 필요
            return .requestPlain
        case .postPasswordVerifyUser(let verifyUserData):
            return .requestJSONEncodable(verifyUserData)
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
            
        case .getTerms:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postLogout:
            if let token = TokenProvider.shared.accessToken {
                return ["accessToken": token]
            }
            return nil
        default:
            return nil
        }
    }
}
