//
//  MemberData.swift
//  CoreDisc
//
//  Created by 김미주 on 7/24/25.
//

import Foundation

struct ProfilePatchData: Codable {
    let newNickname: String?
    let newUsername: String?
}

struct PasswordPatchData: Codable {
    let username: String?
    let newPassword: String?
    let passwordCheck: String?
}

struct MyhomePasswordPatchData: Codable {
    let password: String?
    let newPassword: String?
    let passwordCheck: String?
}


