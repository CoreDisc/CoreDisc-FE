//
//  SharedQuestionResponse.swift
//  CoreDisc
//
//  Created by 이채은 on 8/15/25.
//
import Foundation

struct SharedQuestionResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SharedQuestionsResult
}

struct SharedQuestionsResult: Codable {
    let mySharedQuestionCnt: Int?
    let mySharedQuestionList: SharedQuestionList?
    let values: [SharedQuestion]?
    let hasNext: Bool?
}

struct SharedQuestionList: Codable {
    let values: [SharedQuestion]
    let hasNext: Bool
}

struct SharedQuestion: Codable, Identifiable {
    let id: Int
    let categories: [SharedCategory]
    let question: String
    let sharedCount: Int
    let isSelected: Bool
    let createdAt: String
}

struct SharedCategory: Codable {
    let categoryId: Int
    let categoryName: String
}
