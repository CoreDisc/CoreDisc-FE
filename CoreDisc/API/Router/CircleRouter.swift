//
//  CircleRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 7/26/25.
//

import Foundation
import Moya

// 친한 친구 관련 API
enum CircleRouter {
    case patchCircle(targetId: Int, isCircle: Bool) // 친한 친구 설정 변경
    case getCircle(cursorId: Int, size: Int) // 친한 친구 목록 조회 // TODO: 옵셔널로 수정 필요
}

extension CircleRouter: APITargetType {
    private static let circlePath = "/api/circle"
    
    var path: String {
        switch self {
        case .patchCircle(let targetId, _):
            return "\(Self.circlePath)/\(targetId)"
        case .getCircle:
            return "\(Self.circlePath)s"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchCircle:
            return .patch
        case .getCircle:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .patchCircle(_, let isCircle):
            return .requestParameters(parameters: ["isCircle": isCircle], encoding: URLEncoding.queryString)
        case .getCircle(let cursorId, let size):
            return .requestParameters(parameters: [
                "cursorId": cursorId,
                "size": size
            ], encoding: URLEncoding.queryString)
        }
    }
}
