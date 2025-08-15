//
//  SeachMembersResponse.swift
//  CoreDisc
//
//  Created by 이채은 on 8/10/25.
//

import Foundation

struct SearchMembersResponse: Decodable {
    let isSuccess: Bool
    let code: String?
    let message: String?
    let result: SearchMembersResult
}

struct SearchMembersResult: Decodable {
    let values: [SearchMemberItem]
    let hasNext: Bool
}

struct SearchMemberItem: Decodable, Identifiable {
    let id: Int
    let nickname: String
    let username: String
    let profileImgDTO: ProfileImgDTO?
}


