//
//  ReportResponse.swift
//  CoreDisc
//
//  Created by 정서영 on 8/15/25.
//

import Foundation

struct ReportResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ReportResult?
}

struct ReportResult: Decodable {
    let year: Int
    let month: Int
    let fixedQuestions: [Question]
    let randomQuestions: [Question]
    let allOneCount: Bool
    let mostSelectedQuestions: [MostSelectedQuestion]?
    let peakTimeZone: String
}

struct Question: Decodable {
    let questionContent: String
}

struct MostSelectedQuestion: Decodable {
    let questionContent: String
    let selectedCount: Int?
}

struct TotalDiscModel: Identifiable {
    let id: UUID
    let question: String
    let category: String
    
    init(question: String, category: String) {
        self.id = UUID()
        self.question = question
        self.category = category
    }
}
