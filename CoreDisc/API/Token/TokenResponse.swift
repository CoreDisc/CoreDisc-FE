//
//  TokenResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 7/24/25.
//

import Foundation

// reissue 응답 받을 때 사용
struct TokenResponse: Codable {
    var accessToken: String
    var refreshToken: String
}
