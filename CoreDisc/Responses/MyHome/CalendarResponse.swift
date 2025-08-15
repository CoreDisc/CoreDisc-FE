//
//  CalendarResponse.swift
//  CoreDisc
//
//  Created by 이채은 on 8/9/25.
//

import Foundation

struct CalendarMonthAPIResponse: Decodable {
    let isSuccess: Bool
    let code: String?
    let message: String?
    let result: CalendarMonthResult
}

struct CalendarMonthResult: Decodable {
    let year: Int
    let month: Int
    let startDay: String
    let days: [CalendarDayDTO]
    let totalDays: Int
    let hasPrevMonth: Bool?
    let hasNextMonth: Bool?
}

struct CalendarDayDTO: Decodable {
    let day: Int
    let postId: Int?
    let recorded: Bool
    let today: Bool
}

struct ContinuousDaysAPIResponse: Decodable {
    let isSuccess: Bool
    let code: String?
    let message: String?
    let result: Int
}
