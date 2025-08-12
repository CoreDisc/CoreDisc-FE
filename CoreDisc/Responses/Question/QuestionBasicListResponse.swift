//
//  QuestionBasicListResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 7/29/25.
//

import Foundation

struct QuestionBasicListResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: QuestionBasicListResult
}

struct QuestionBasicListResult: Codable {
    let values: [QuestionBasicListValue]
    let hasNext: Bool
}

struct QuestionBasicListValue: Identifiable, Codable {
    let id: Int
    let questionType: String
    let question: String
    let isSelected: Bool
    let isFavorite: Bool
    let createdAt: String
}
