//
//  FindIdResponse.swift
//  CoreDisc
//
//  Created by 정서영 on 8/3/25.
//

import Foundation

struct FindIdResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: FindIdResult?
}

struct FindIdResult: Decodable {
    let username: String
}
