//
//  LoginResponse.swift
//  CoreDisc
//
//  Created by 정서영 on 8/1/25.
//

import Foundation

struct LoginResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: LoginResult?
}

struct LoginResult: Decodable {
    let id: Int
    let accessToken: String
    let refreshToken: String
}
