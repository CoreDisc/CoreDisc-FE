//
//  DiscRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 7/26/25.
//

import Foundation
import Moya

// 디스크 관련 API 연결
enum DiscRouter {
    case patchCoverImage(discId: Int, coverImageUrl: String) // 디스크 커버 이미지 변경
    case patchCoverColor(discId: Int, coverColor: String) // 디스크 커버 색깔 변경
    case getDiscsList // 디스크 목록 조회
    case getDiscs(discId: Int) // 디스크 조회
}

extension DiscRouter: APITargetType {
    private static let discPath = "/api/reports/discs"
    
    var path: String {
        switch self {
        case .patchCoverImage(let discId, _):
            return "\(Self.discPath)/\(discId)/cover/image"
        case .patchCoverColor(let discId, _):
            return "\(Self.discPath)/\(discId)/cover/color"
        case .getDiscsList:
            return "\(Self.discPath)"
        case .getDiscs(let discId):
            return "\(Self.discPath)/\(discId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchCoverImage, .patchCoverColor:
            return .patch
        case .getDiscsList, .getDiscs:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .patchCoverImage(_, let coverImageUrl):
            return .requestParameters(parameters: ["coverImageUrl": coverImageUrl], encoding: JSONEncoding.default)
        case .patchCoverColor(_, let coverColor):
            return .requestParameters(parameters: ["coverColor": coverColor], encoding: JSONEncoding.default)
        case .getDiscsList:
            return .requestPlain
        case .getDiscs:
            return .requestPlain
        }
    }
}
