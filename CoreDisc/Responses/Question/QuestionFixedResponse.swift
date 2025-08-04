//
//  QuestionFixedResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/1/25.
//

import Foundation

struct QuestionFixedResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: QuestionFixedResult
}

struct QuestionFixedResult: Codable {
    let id: Int
    let createdAt: String
}
