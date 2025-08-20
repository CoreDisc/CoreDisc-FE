//
//  TokenResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 7/24/25.
//

import Foundation

struct TokenResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: TokenResult
}

// reissue 응답 받을 때 사용
struct TokenResult: Decodable {
    var accessToken: String
    var refreshToken: String
}
