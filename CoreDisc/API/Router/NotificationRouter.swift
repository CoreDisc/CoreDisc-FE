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
    
    case getReminder // 리마인더 알림 설정 조회
    case patchReminder(notificationData: NotificationData) // 리마인더 알림 설정 변경
    
    case getNotification(cursorId: Int?, size: Int?) // 알림 목록 조회
    case getNotificationUnread // 안읽은 알림 존재 여부
    
    // device
    case postDeviceToken(token: String) // 디바이스 토큰 설정
}

extension NotificationRouter: APITargetType {
    private static let notificationPath = "/api/notification"
    
    var path: String {
        switch self {
        case .patchNotificationRead(let notificationId):
            return "\(Self.notificationPath)s/\(notificationId)/read"
        case .patchNotificationReadAll:
            return "\(Self.notificationPath)s/read-all"
            
        case .getReminder, .patchReminder:
            return "\(Self.notificationPath)-settings/reminder"
            
        case .getNotification:
            return "\(Self.notificationPath)s"
        case .getNotificationUnread:
            return "\(Self.notificationPath)s/unread"
            
        case .postDeviceToken:
            return "/api/device-token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchNotificationRead, .patchReminder, .patchNotificationReadAll:
                .patch
        case .getNotification, .getReminder, .getNotificationUnread:
                .get
        case .postDeviceToken:
                .post
        }
    }
    
    var task: Task {
        switch self {
        case .patchNotificationRead:
            return .requestPlain
        case .patchNotificationReadAll:
            return .requestPlain
            
        case .getReminder:
            return .requestPlain
        case .patchReminder(let notificationData):
            return .requestJSONEncodable(notificationData)
            
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
            
        case .postDeviceToken(let token):
            return .requestParameters(
                parameters: ["token": token, "deviceType": "iOS"],
                encoding: JSONEncoding.default
            )
        }
    }
}
