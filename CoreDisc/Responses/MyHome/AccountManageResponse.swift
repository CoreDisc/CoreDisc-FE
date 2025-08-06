//
//  AccountManageResponse.swift
//  CoreDisc
//
//  Created by 정서영 on 8/7/25.
//

struct ChangeMyPwResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String?
}
