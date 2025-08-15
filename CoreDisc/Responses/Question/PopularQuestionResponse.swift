//
//  PopularQuestionResponse.swift
//  CoreDisc
//
//  Created by 이채은 on 8/15/25.
//

import Foundation

struct PopularQuestionResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PopularQuestionResult
}

struct PopularQuestionResult: Codable {
    let startDate: String
    let endDate: String
    let popularQuestionList: [PopularQuestion]
}

struct PopularQuestion: Codable, Identifiable {
    let id: Int
    let username: String
    let question: String
    let isSelected: Bool
    let sharedCount: Int
}

