//
//  NotificationResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/7/25.
//

import Foundation

// 알림 목록 조회
struct NotificationResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: NotificationResult
}

struct NotificationResult: Decodable {
    let values: [NotificationValues]
    let hasNext: Bool
}

struct NotificationValues: Decodable, Identifiable, Hashable {
    let notificationId: Int
    let type: String
    let content: String
    let targetId: Int
    let senderId: Int
    let senderUsername: String
    let senderNickname: String
    let profileImgDTO: NotificationProfileImgDTO
    let isRead: Bool
    let createdAt: String
    let timeStamp: String

    // Identifiable
    var id: Int { notificationId }

    // Hashable
    func hash(into hasher: inout Hasher) { hasher.combine(notificationId) }
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.notificationId == rhs.notificationId }
}

struct NotificationProfileImgDTO: Decodable {
    let profileImgId: Int
    let imageUrl: String?
}

// 개별 알림 읽음
struct NotificationReadResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

// 안 읽은 알림
struct NotificationUnreadResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: Bool
}
