//
//  ReportRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 7/26/25.
//

import Foundation
import Moya

// 사용자별 세부 통계 API 연결
enum ReportRouter {
    case getTopSelection(year: Int, month: Int) // 기간별 게시글의 daily 항목 최다 답변 조회
    case getDetails(year: Int, month: Int) // 사용자가 특정 달에 작성한 일기 내용 전체 출력
    case getMonthlyReport(year: Int, month: Int) // 월별 리포트 조희
}

extension ReportRouter: APITargetType {
    private static let reportPath = "/api/reports"
    
    var path: String {
        switch self {
        case .getTopSelection:
            return "\(Self.reportPath)/daily/top-selection"
        case .getDetails:
            return "\(Self.reportPath)/daily/details"
        case .getMonthlyReport:
            return "\(Self.reportPath)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTopSelection, .getDetails, .getMonthlyReport:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case  .getTopSelection(let year, let month),
                .getDetails(let year, let month),
                .getMonthlyReport(let year, let month):
            return .requestParameters(parameters: [
                "year": year,
                "month": month
            ], encoding: URLEncoding.queryString)
        }
    }
}
