//
//  DeleteQuestionResponse.swift
//  CoreDisc
//
//  Created by 이채은 on 8/21/25.
//

import Foundation

struct DeleteQuestionResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String?
}
