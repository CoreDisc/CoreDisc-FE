//
//  SearchRouter.swift
//  CoreDisc
//
//  Created by 이채은 on 8/10/25.
//

import Foundation
import Moya

enum SearchRouter {
    case getRecent(cursorSearchedAt: String?, size: Int?)
    case deleteHistory(historyId: Int)
    case searchMembers(keyword: String, record: Bool?, cursorId: Int?, size: Int?)
}

extension SearchRouter: APITargetType {
    var path: String {
        switch self {
        case .getRecent:
            return "/api/search/members/history"
        case .deleteHistory(let historyId):
            return "/api/search/members/history/\(historyId)"
        case .searchMembers:
            return "/api/search/members"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRecent:
            return .get
        case .deleteHistory:
            return .delete
        case .searchMembers:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getRecent(let cursor, let size):
            var params: [String: Any] = [:]
            if let cursor { params["cursorSearchedAt"] = cursor }
            if let size { params["size"] = size }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .deleteHistory:
            return .requestPlain
            
        case .searchMembers(let keyword, let record, let cursorId, let size):
            var params: [String: Any] = ["keyword": keyword]
            if let record { params["record"] = record }      // true면 저장, false/생략이면 저장 안함
            if let cursorId { params["cursorId"] = cursorId }
            if let size { params["size"] = size }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}

