//
//  KakaoResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 7/26/25.
//

import Foundation

struct KakaoResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: TokenData
}

struct TokenData: Codable {
    let id: Int
    let accessToken: String
    let refreshToken: String
}
