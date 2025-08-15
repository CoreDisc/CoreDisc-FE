//
//  NotificationData.swift
//  CoreDisc
//
//  Created by 김미주 on 8/15/25.
//

import Foundation

struct NotificationData: Codable {
    let dailyReminderEnabled: Bool?
    let dailyReminderHour: Int?
    let dailyReminderMinute: Int?
    let unansweredReminderEnabled: Bool?
    let unansweredReminderHour: Int?
    let unansweredReminderMinute: Int?
}
