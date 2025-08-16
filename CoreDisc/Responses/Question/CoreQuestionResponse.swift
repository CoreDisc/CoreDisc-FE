//
//  CoreQuestionResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/16/25.
//

import Foundation

struct CoreQuestionResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: CoreQuestionResult
}

struct CoreQuestionResult: Decodable {
    let values: [CoreQuestionValue]
    let hasNext: Bool
}

struct CoreQuestionValue: Decodable {
    let id: Int
    let questionType: String
    let question: String
    let createdAt: String
}

