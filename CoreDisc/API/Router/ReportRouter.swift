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
    case getQuestionList(year: Int, month: Int) // 기간별 전체 질문 목록 조회
    case getPeakHours(year: Int, month: Int) // 기간별 응답 시간대 횟수 조회
    case getMostSelected(year: Int, month: Int) // 기간별 최다 선택된 랜덤 질문 3순위 조회
    case getTopSelection(year: Int, month: Int) // 기간별 게시글의 daily 항목 최다 답변 조회
    case getDetails(year: Int, month: Int) // 사용자가 특정 달에 작성한 일기 내용 전체 출력
}

extension ReportRouter: APITargetType {
    private static let reportPath = "/api/reports"
    
    var path: String {
        switch self {
        case .getQuestionList:
            return "\(Self.reportPath)/question-list"
        case .getPeakHours:
            return "\(Self.reportPath)/peak-hours"
        case .getMostSelected:
            return "\(Self.reportPath)/most-selected"
        case .getTopSelection:
            return "\(Self.reportPath)/daily/top-selection"
        case .getDetails:
            return "\(Self.reportPath)/daily/details"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getQuestionList, .getPeakHours, .getMostSelected, .getTopSelection, .getDetails:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getQuestionList(let year, let month),
                .getPeakHours(let year, let month),
                .getMostSelected(let year, let month),
                .getTopSelection(let year, let month),
                .getDetails(let year, let month):
            return .requestParameters(parameters: [
                "year": year,
                "month": month
            ], encoding: URLEncoding.queryString)
        }
    }
}
