//
//  FindPwResponse.swift
//  CoreDisc
//
//  Created by 정서영 on 8/7/25.
//

import Foundation

struct FindPwResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

struct VerifyPwCodeResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: VerifyPwResult?
}

struct VerifyPwResult: Decodable {
    let verified: Bool
}

struct ChangePwResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ChangePwResult?
}

struct ChangePwResult: Decodable {
    let newPassword: String
}
