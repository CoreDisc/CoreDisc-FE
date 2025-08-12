//
//  NotificationRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 8/7/25.
//

import Foundation
import Moya

// 알림 관련 API 연결
enum NotificationRouter {
    case patchNotificationRead(notificationId: Int) // 개별 알림 읽음 처리
    case patchNotificationReadAll // 전체 알림 읽음 처리
    case getNotification(cursorId: Int?, size: Int?) // 알림 목록 조회
    case getNotificationUnread // 안읽은 알림 존재 여부
}

extension NotificationRouter: APITargetType {
    private static let notificationPath = "/api/notifications"
    
    var path: String {
        switch self {
        case .patchNotificationRead(let notificationId):
            return "\(Self.notificationPath)/\(notificationId)/read"
        case .patchNotificationReadAll:
            return "\(Self.notificationPath)/read-all"
        case .getNotification:
            return "\(Self.notificationPath)"
        case .getNotificationUnread:
            return "\(Self.notificationPath)/unread"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchNotificationRead, .patchNotificationReadAll:
                .patch
        case .getNotification, .getNotificationUnread:
                .get
        }
    }
    
    var task: Task {
        switch self {
        case .patchNotificationRead:
            return .requestPlain
        case .patchNotificationReadAll:
            return .requestPlain
        case .getNotification(let cursorId, let size):
            var parameters: [String: Any] = [:]
            if let cursorId = cursorId {
                parameters["cursorId"] = cursorId
            }
            if let size = size {
                parameters["size"] = size
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getNotificationUnread:
            return .requestPlain
        }
    }
}
