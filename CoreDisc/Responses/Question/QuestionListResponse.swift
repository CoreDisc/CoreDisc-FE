//
//  QuestionListResponse.swift
//  CoreDisc
//
//  Created by 이채은 on 8/15/25.
//

import Foundation

struct QuestionListResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: QuestionListResult
}

struct QuestionListResult: Codable {
    let values: [QuestionListItem]
    let hasNext: Bool
}

struct QuestionListItem: Codable, Identifiable {
    let id: Int
    let categories: [QuestionListCategory]
    let question: String
    let sharedCount: Int
    let isSelected: Bool
    let createdAt: String
}

struct QuestionListCategory: Codable {
    let categoryId: Int
    let categoryName: String
}

