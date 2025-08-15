//
//  SummaryResponse.swift
//  CoreDisc
//
//  Created by 정서영 on 8/15/25.
//

import Foundation

struct SummaryTopResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SummaryTopResult?
}

struct SummaryTopResult: Decodable {
    let year: Int
    let month: Int
    let dailyList: [DailyData]
}

struct DailyData: Decodable {
    let dailyType: String
    let optionContent: String
    let selectionCount: Int
}

struct ExtraDiscModel: Identifiable {
    let id = UUID()
    let text: String
    let date: String
}
