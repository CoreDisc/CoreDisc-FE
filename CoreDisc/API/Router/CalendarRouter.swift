//
//  CalendarRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 7/26/25.
//

import Foundation
import Moya

// 캘린더 API 연결
enum CalendarRouter {
    case getCalendar(year: Int, month: Int) // 월간 답변 기록 캘린더 조회
}

extension CalendarRouter: APITargetType {
    var path: String {
        switch self {
        case .getCalendar:
            return "/api/reports/calendar"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCalendar:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getCalendar(let year, let month):
            return .requestParameters(parameters: [
                "year": year,
                "month": month
            ], encoding: URLEncoding.queryString)
        }
    }
}
