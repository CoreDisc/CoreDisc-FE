//
//  QuestionRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 7/24/25.
//

import Foundation
import Moya

// /api/questions API 연결
enum QuestionRouter {
    case postRandom(randomData: RandomData) // 랜덤 질문 선택
    case postPersonal(personalData: OfficialPersonalData) // 내가 작성한 질문 저장하기
    case postOfficial(officialData: OfficialPersonalData) // 내가 작성한 질문 공유하기
    case postOfficialSave(questionId: Int) // 타사용자가 작성한 공유질문 저장
    case postFixed(fixedData: FixedData) // 고정 질문 선택
    
    case getSelected // 선택한 고정&랜덤 질문 조회
    case getOfficialMine // 내가 발행한 공유질문 리스트 조회
    case getCategories // 질문 카테고리 리스트 조회
    case getBasicSearch // 기본 질문 리스트 검색
    case getBasicCategories(categoryId: Int) // 기본 질문 리스트 조회
    
    case deletePersonal(questionId: Int) // 작성하여 저장한 질문 삭제하기 (커스텀 질문 삭제)
    case deleteOfficial(questionId: Int) // 저장한 공유질문 삭제
}

extension QuestionRouter: APITargetType {
    private static let questionPath = "/api/questions"
    
    var path: String {
        switch self {
        case .postRandom:
            return "\(Self.questionPath)/random"
        case .postPersonal:
            return "\(Self.questionPath)/personal"
        case .postOfficial:
            return "\(Self.questionPath)/official"
        case .postOfficialSave(let questionId):
            return "\(Self.questionPath)/official/\(questionId)"
        case .postFixed:
            return "\(Self.questionPath)/fixed"
            
        case .getSelected:
            return "\(Self.questionPath)/selected"
        case .getOfficialMine:
            return "\(Self.questionPath)/official/mine"
        case .getCategories:
            return "\(Self.questionPath)/categories"
        case .getBasicSearch:
            return "\(Self.questionPath)/basic/search"
        case .getBasicCategories(let categoryId):
            return "\(Self.questionPath)/basic/categories/\(categoryId)"
            
        case .deletePersonal(let questionId):
            return "\(Self.questionPath)/personal/\(questionId)"
        case .deleteOfficial(let questionId):
            return "\(Self.questionPath)/official/saved/\(questionId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postRandom, .postPersonal, .postOfficial, .postOfficialSave, .postFixed:
            return .post
        case .getSelected, .getOfficialMine, .getCategories, .getBasicSearch, .getBasicCategories:
            return .get
        case .deletePersonal, .deleteOfficial:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .postRandom(let randomData):
            return .requestJSONEncodable(randomData)
        case .postPersonal(let personalData):
            return .requestJSONEncodable(personalData)
        case .postOfficial(let officialData):
            return .requestJSONEncodable(officialData)
        case .postOfficialSave:
            return .requestPlain
        case .postFixed(let fixedData):
            return .requestJSONEncodable(fixedData)
            
        case .getSelected:
            return .requestPlain
        case .getOfficialMine:
            return .requestPlain // TODO: 쿼리
        case .getCategories:
            return .requestPlain
        case .getBasicSearch:
            return .requestPlain // TODO: 쿼리
        case .getBasicCategories:
            return .requestPlain // TODO: 쿼리
            
        case .deletePersonal:
            return .requestPlain
        case .deleteOfficial:
            return .requestPlain
        }
    }
}
