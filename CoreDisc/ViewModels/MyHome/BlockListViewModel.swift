//
//  BlockListViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/21/25.
//

import Foundation

@Observable
class BlockListViewModel {
    // 샘플 데이터
    let blockSample: [BlockListModel] = [
        .init(blockedId: 1, blockedNickname: "닉네임1", blockedUsername: "user_name1"),
        .init(blockedId: 2, blockedNickname: "닉네임2", blockedUsername: "user_name2"),
        .init(blockedId: 3, blockedNickname: "닉네임3", blockedUsername: "user_name3"),
        .init(blockedId: 4, blockedNickname: "닉네임4", blockedUsername: "user_name4"),
        .init(blockedId: 5, blockedNickname: "닉네임5", blockedUsername: "user_name5"),
        .init(blockedId: 6, blockedNickname: "닉네임6", blockedUsername: "user_name6"),
        .init(blockedId: 7, blockedNickname: "닉네임7", blockedUsername: "user_name7"),
        .init(blockedId: 8, blockedNickname: "닉네임8", blockedUsername: "user_name8"),
        .init(blockedId: 9, blockedNickname: "닉네임9", blockedUsername: "user_name9"),
        .init(blockedId: 10, blockedNickname: "닉네임10", blockedUsername: "user_name10"),
        .init(blockedId: 11, blockedNickname: "닉네임11", blockedUsername: "user_name11"),
        .init(blockedId: 12, blockedNickname: "닉네임12", blockedUsername: "user_name12"),
        .init(blockedId: 13, blockedNickname: "닉네임13", blockedUsername: "user_name13"),
        .init(blockedId: 14, blockedNickname: "닉네임14", blockedUsername: "user_name14"),
        .init(blockedId: 15, blockedNickname: "닉네임15", blockedUsername: "user_name15"),
        .init(blockedId: 16, blockedNickname: "닉네임16", blockedUsername: "user_name16"),
        .init(blockedId: 17, blockedNickname: "닉네임17", blockedUsername: "user_name17"),
        .init(blockedId: 18, blockedNickname: "닉네임18", blockedUsername: "user_name18"),
        .init(blockedId: 19, blockedNickname: "닉네임19", blockedUsername: "user_name19"),
        .init(blockedId: 20, blockedNickname: "닉네임20", blockedUsername: "user_name20")
    ]
}
