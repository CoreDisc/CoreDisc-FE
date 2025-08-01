//
//  QuestionSelectedResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/1/25.
//

import Foundation

struct QuestionSelectedResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [QuestionSelectedResult]
}

struct QuestionSelectedResult: Codable {
    let id: Int?
    let questionOrder: Int
    let question: String?
    let questionType: String?
}
