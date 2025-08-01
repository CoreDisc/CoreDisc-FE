//
//  EditCheckUsernameResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 7/31/25.
//

import Foundation

struct EditCheckUsernameResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EditCheckUsernameResult
}

struct EditCheckUsernameResult: Decodable {
    let duplicated: Bool
}
