//
//  NotificationSettingResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 8/15/25.
//

import Foundation

struct NotificationSettingResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: NotificationSettingResult
}

struct NotificationSettingResult: Decodable {
    let dailyReminderEnabled: Bool
    let unansweredReminderEnabled: Bool
    let dailyReminderHour: Int
    let dailyReminderMinute: Int
    let unansweredReminderHour: Int
    let unansweredReminderMinute: Int
    
    static let empty = NotificationSettingResult(
        dailyReminderEnabled: true,
        unansweredReminderEnabled: false,
        dailyReminderHour: 0,
        dailyReminderMinute: 0,
        unansweredReminderHour: 0,
        unansweredReminderMinute: 0
    )
}
