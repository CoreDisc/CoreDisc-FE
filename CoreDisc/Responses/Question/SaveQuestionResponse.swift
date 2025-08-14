//
//  SaveQuestionResponse.swift
//  CoreDisc
//
//  Created by 이채은 on 8/15/25.
//

import Foundation

struct SaveQuestionResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SaveQuestionResult
}

struct SaveQuestionResult: Codable {
    let id: Int
    let createdAt: String
}
