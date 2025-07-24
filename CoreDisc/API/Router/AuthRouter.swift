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
    case postSignup(signupData: SignupData)
    
    case getCheckEmail(email: String)
    case getCheckUsername(username: String)
    case getCheckNickname(nickname: String)
    
    case postSendCode(email: String)
    case postVerifyCode(verifyCodeData: VerifyCodeData)
    case postLogin(loginData: LoginData)
    // 소셜 로그인
    case postReissue
    case postLogout
    case postUsername(usernameData: UsernameData)
    case postVerifyUser(verifyUserData: VerifyUserData)
}

extension AuthRouter: APITargetType {
    private static let authPath = "/api/auth"
    
    var path: String {
        switch self {
        case .postSignup:
            return "\(Self.authPath)/signup"
            
        case .getCheckEmail:
            return "\(Self.authPath)/check-email"
        case .getCheckUsername:
            return "\(Self.authPath)/check-username"
        case .getCheckNickname:
            return "\(Self.authPath)/check-nickname"
            
        case .postSendCode:
            return "\(Self.authPath)/send-code"
        case .postVerifyCode:
            return "\(Self.authPath)/verify-code"
        case .postLogout:
            return "\(Self.authPath)/logout"
        case .postReissue:
            return "\(Self.authPath)/reissue"
        case .postLogin:
            return "\(Self.authPath)/login"
        case .postUsername:
            return "\(Self.authPath)/username"
        case .postVerifyUser:
            return "\(Self.authPath)/verify-user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCheckEmail, .getCheckUsername, .getCheckNickname:
            return .get
        case .postSignup, .postSendCode, .postVerifyCode, .postLogout, .postReissue, .postLogin, .postUsername, .postVerifyUser:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postSignup(let signupData):
            return .requestJSONEncodable(signupData)
            
        case .getCheckEmail(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
        case .getCheckUsername(let username):
            return .requestParameters(parameters: ["username": username], encoding: URLEncoding.queryString)
        case .getCheckNickname(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
            
        case .postSendCode(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.default)
        case .postVerifyCode(let verifyCodeData):
            return .requestJSONEncodable(verifyCodeData)
        case .postLogout:
            return .requestPlain
        case .postReissue:
            return .requestPlain
        case .postLogin(let loginData):
            return .requestJSONEncodable(loginData)
        case .postUsername(let usernameData):
            return .requestJSONEncodable(usernameData)
        case .postVerifyUser(let verifyUserData):
            return .requestJSONEncodable(verifyUserData)
        }
    }
}
