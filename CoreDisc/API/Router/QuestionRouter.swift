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
    case postOfficialSave(questionId: Int, selectedQuestionType: String) // 타사용자가 작성한 공유질문 저장
    case postFixed(fixedData: FixedData) // 고정 질문 선택
    
    case getSelected // 선택한 고정&랜덤 질문 조회
    case getOfficialMine(cursorId: Int?, size: Int?) // 내가 발행한 공유질문 리스트 조회 ver 발행 개수
    case getOfficialMineByCategory(categoryId: Int, cursorId: Int?, size: Int?) // 내가 발행한 공유질문 리스트 조회 ver 카테고리 필터링
    // 저장한 공유질문 리스트 조회
    case getOfficialSavedMine(categoryId: Int?, cursorId: Int?, size: Int?)
    case getCategories // 질문 카테고리 리스트 조회
    case getCategoriesSearch(keyword: String) // 질문 카테고리 리스트 조회 (검색)
    case getBasic(
        categoryId: Int,
        cursorCreatedAt: String?,
        cursorQuestionType: String?,
        cursorId: Int?,
        size: Int?
    ) // 기본 질문 리스트 조회
    case getBasicSearch(
        categoryId: Int,
        keyword: String,
        cursorCreatedAt: String?,
        cursorQuestionType: String?,
        cursorId: Int?,
        size: Int?
    ) // 기본 질문 리스트 조회 (검색)
    
    case deletePersonal(questionId: Int) // 작성하여 저장한 질문 삭제하기 (커스텀 질문 삭제)
    case deleteOfficial(savedId: Int) // 저장한 공유질문 삭제
    case getPopular(selectedQuestionType: String) // 인기 질문 조회
    case patchPersonal(questionId: Int, categoryIdList: [Int], question: String) // 작성 질문 재작성
    
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
        case .postOfficialSave(let questionId, _):
            return "\(Self.questionPath)/official/\(questionId)"
        case .postFixed:
            return "\(Self.questionPath)/fixed"
            
        case .getSelected:
            return "\(Self.questionPath)/selected"
        case .getOfficialMine, .getOfficialMineByCategory:
            return "\(Self.questionPath)/official/mine"
        case .getOfficialSavedMine:
            return "\(Self.questionPath)/official/saved/mine"
        case .getCategories:
            return "\(Self.questionPath)/categories"
        case .getCategoriesSearch:
            return "\(Self.questionPath)/categories/search"
        case .getBasic:
            return "\(Self.questionPath)/basic"
        case .getBasicSearch:
            return "\(Self.questionPath)/basic/search"
            
        case .deletePersonal(let questionId):
            return "\(Self.questionPath)/personal/\(questionId)"
        case .deleteOfficial(let savedId):
            return "\(Self.questionPath)/official/saved/\(savedId)"
        case .getPopular:
            return "\(Self.questionPath)/popular"
        case .patchPersonal(let questionId, _, _):
            return "\(Self.questionPath)/personal/\(questionId)"
            
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .postRandom, .postPersonal, .postOfficial, .postOfficialSave, .postFixed:
            return .post
        case .getSelected, .getOfficialMine, .getCategories, .getCategoriesSearch, .getBasic, .getBasicSearch, .getPopular, .getOfficialMineByCategory, .getOfficialSavedMine:
            return .get
        case .deletePersonal, .deleteOfficial:
            return .delete
        case .patchPersonal:
            return .patch
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
        case .postOfficialSave(_, let selectedQuestionType):
            return .requestParameters(parameters: ["selectedQuestionType": selectedQuestionType], encoding: JSONEncoding.default)
        case .postFixed(let fixedData):
            return .requestJSONEncodable(fixedData)
            
        case .getSelected:
            return .requestPlain
        case .getOfficialMine(let cursorId, let size):
            var params: [String: Any] = [:]
            if let cursorId = cursorId {
                params["cursorId"] = cursorId
            }
            if let size = size {
                params["size"] = size
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getOfficialMineByCategory(let categoryId, let cursorId, let size):
            var params: [String: Any] = ["categoryId": categoryId]
            if let cursorId = cursorId { params["cursorId"] = cursorId }
            if let size = size { params["size"] = size }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getOfficialSavedMine(let categoryId, let cursorId, let size):
            var params: [String: Any] = [:]
            if let categoryId = categoryId, categoryId != 0 {
                params["categoryId"] = categoryId
            }
            if let cursorId = cursorId {
                params["cursorId"] = cursorId
            }
            if let size = size {
                params["size"] = size
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)

        case .getCategories:
            return .requestPlain
        case .getCategoriesSearch(let keyword):
            return .requestParameters(parameters: ["keyword": keyword], encoding: URLEncoding.queryString)
        case .getBasic(
            let categoryId,
            let cursorCreatedAt,
            let cursorQuestionType,
            let cursorId,
            let size
        ):
            var parameters: [String: Any] = [
                "categoryId": categoryId
            ]
            if let createdAt = cursorCreatedAt {
                parameters["cursorCreatedAt"] = createdAt
            }
            if let type = cursorQuestionType {
                parameters["cursorQuestionType"] = type
            }
            if let id = cursorId {
                parameters["cursorId"] = id
            }
            if let size = size {
                parameters["size"] = size
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getBasicSearch(
            let categoryId,
            let keyword,
            let cursorCreatedAt,
            let cursorQuestionType,
            let cursorId,
            let size
        ):
            var parameters: [String: Any] = [
                "categoryId": categoryId,
                "keyword": keyword
            ]
            if let createdAt = cursorCreatedAt {
                parameters["cursorCreatedAt"] = createdAt
            }
            if let type = cursorQuestionType {
                parameters["cursorQuestionType"] = type
            }
            if let id = cursorId {
                parameters["cursorId"] = id
            }
            if let size = size {
                parameters["size"] = size
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .deletePersonal:
            return .requestPlain
        case .deleteOfficial:
            return .requestPlain
        case .getPopular(let selectedQuestionType):
            return .requestParameters(
                parameters: ["selectedQuestionType": selectedQuestionType],
                encoding: URLEncoding.queryString
            )
        case .patchPersonal(_, let categoryIdList, let question):
            let params: [String: Any] = [
                "categoryIdList": categoryIdList,
                "question": question
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
}
