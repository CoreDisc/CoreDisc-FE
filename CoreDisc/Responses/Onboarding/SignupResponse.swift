//
//  SignupResponse.swift
//  CoreDisc
//
//  Created by 정서영 on 8/1/25.
//

import Foundation

struct SendCodeResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SendResult?
}

struct SendResult: Decodable {
    let email: String
}

struct VerifyCodeResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: VerifyResult?
}

struct VerifyResult: Decodable {
    let verified: Bool
}

struct SignupResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SignupResult?
}

struct SignupResult: Decodable {
    let id: Int
    let createdAt: String
}
