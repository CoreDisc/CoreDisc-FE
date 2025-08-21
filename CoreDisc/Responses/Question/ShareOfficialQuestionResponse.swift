//
//  ShareOfficialQuestionResponse.swift
//  CoreDisc
//
//  Created by 이채은 on 8/22/25.
//

import Foundation
//내가 공유한 질문 조회
struct ShareOfficialQuestionResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ShareOfficialQuestionResult
}

struct ShareOfficialQuestionResult: Codable {
    let values: [ShareOfficialQuestionItem]
    let hasNext: Bool
}

struct ShareOfficialQuestionItem: Codable, Identifiable {
    let id: Int
    let categories: [QuestionListCategory]
    let question: String
    let sharedCount: Int
    let isSelected: Bool
    let createdAt: String
}
