//
//  UserData.swift
//  CoreDisc
//
//  Created by 김미주 on 7/23/25.
//

import Foundation

// 회원가입
struct SignupData: Codable {
    let email: String
    let name: String
    let username: String
    let password: String
    let passwordCheck: String
    let agreedTermsIds: [Int]
}

// 코드 인증 (회원가입 / 비밀번호 변경)
enum EmailRequestType: String, Codable {
    case resetPassword = "RESET_PASSWORD"
    case signup = "SIGNUP"
}

struct VerifyCodeData: Codable {
    let username: String
    let code: String
    let emailRequestType: EmailRequestType
}

// 일반 로그인
struct LoginData: Codable {
    let username: String
    let password: String
}

// 아이디 찾기
struct UsernameData: Codable {
    let name: String
    let email: String
}

// 비밀번호 변경 - 사용자 검증
struct VerifyUserData: Codable {
    let name: String
    let username: String
}
