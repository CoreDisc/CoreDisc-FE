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

enum SendResult: Decodable {
    case success(String)
    case error(ValidationError)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            self = .success(stringValue)
        } else if let errorValue = try? container.decode(ValidationError.self) {
            self = .error(errorValue)
        } else {
            throw DecodingError.typeMismatch(SendResult.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Cannot decode SendResult"))
        }
    }
}

struct ValidationError: Decodable {
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

struct TermsResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [TermsData]
}

struct TermsData: Decodable {
    let termsId: Int
    let title: String
    let content: String
    let version: Int
    let isRequired: Bool
}

struct EmailCheckResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EmailResult
}

struct EmailResult: Decodable {
    let duplicated: Bool
}

struct UsernameCheckResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UsernameResult
}

struct UsernameResult: Decodable {
    let duplicated: Bool
}

struct NameCheckResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: NameResult
}

struct NameResult: Decodable {
    let duplicated: Bool
}
