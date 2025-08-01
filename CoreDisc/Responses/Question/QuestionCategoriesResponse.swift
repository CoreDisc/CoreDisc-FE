//
//  QuestionCategoriesResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 7/29/25.
//

import Foundation

struct QuestionCategoriesResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [QuestionCategoriesResult]
}

struct QuestionCategoriesResult: Codable {
    let id: Int
    let name: String
    let count: Int
}
