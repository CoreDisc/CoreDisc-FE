//
//  UserInfo.swift
//  CoreDisc
//
//  Created by 김미주 on 7/24/25.
//

import Foundation

// 사용자 토큰 저장
// Keychain에 저장하거나 불러올 때 사용
struct UserInfo: Codable {
    var accessToken: String?
    var refreshToken: String?
}
