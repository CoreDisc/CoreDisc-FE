//
//  CircleResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/5/25.
//

import Foundation

// MARK: - 친한 친구 설정 변경
struct CircleResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}
