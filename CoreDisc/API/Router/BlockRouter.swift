//
//  BlockRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 7/26/25.
//

import Foundation
import Moya

// 차단 관련 API 연결
enum BlockRouter {
    case postBlock(targetId: Int) // 차단
    case deleteBlock(targetId: Int) // 차단 취소
    case getBlock(cursorId: Int, size: Int) // 차단한 유저 목록 조회
}

extension BlockRouter: APITargetType {
    private static let blockPath = "/api/block"
    
    var path: String {
        switch self {
        case .postBlock(let targetId):
            return "\(Self.blockPath)/\(targetId)"
        case .deleteBlock(let targetId):
            return "\(Self.blockPath)/\(targetId)"
        case .getBlock:
            return Self.blockPath
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postBlock:
            return .post
        case .deleteBlock:
            return .delete
        case .getBlock:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .postBlock, .deleteBlock:
            return .requestPlain
        case .getBlock(let cursorId, let size):
            return .requestParameters(parameters: [
                "cursorId": cursorId,
                "size": size
            ], encoding: URLEncoding.queryString)
        }
    }
}
