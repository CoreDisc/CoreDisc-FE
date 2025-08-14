//
//  DeviceTokenResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/15/25.
//

import Foundation

struct DeviceTokenResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: DeviceTokenResult
}

struct DeviceTokenResult: Decodable {
    let id: Int
    let token: String
    let deviceType: String
    let createdAt: String
    let active: Bool
}
