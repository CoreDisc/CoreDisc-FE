//
//  QuestionBasicViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/13/25.
//

import Foundation
import SwiftUI

class QuestionBasicViewModel: ObservableObject {
    // 기본
    @Published var categoryItem: [QuestionBasicCategoryModel] = []
    @Published var questionListMap: [UUID: [QuestionBasicListValue]] = [:]
    @Published var hasNextPageMap: [UUID: Bool] = [:]
    
    // 검색
    @Published var searchCategoryItem: [QuestionBasicCategoryModel] = []
    @Published var searchQuestionListMap: [UUID: [QuestionBasicListValue]] = [:]
    @Published var searchHasNextPageMap: [UUID: Bool] = [:]

    private let basicProvider = APIManager.shared.createProvider(for: QuestionRouter.self)
    
    // MARK: - Functions
    func fetchCategories() {
        basicProvider.request(.getCategories) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(QuestionCategoriesResponse.self, from: response.data)

                    DispatchQueue.main.async {
                        self.categoryItem = decodedData.result.map { QuestionBasicCategoryModel(from: $0) }
                    }
                } catch {
                    print("GetQuestionCategories 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("카테고리를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetQuestionCategories API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("카테고리를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func fetchSearchCategories(keyword: String) {
        basicProvider.request(.getCategoriesSearch(keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(QuestionCategoriesResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        self.searchCategoryItem = result.map { QuestionBasicCategoryModel(from: $0) }
                    }
                } catch {
                    print("GetQuestionCategoriesSearch 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("검색된 카테고리를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetQuestionCategoriesSearch API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("검색된 카테고리를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func fetchBasicLists(
        categoryUUID: UUID,
        categoryId: Int,
        cursorCreatedAt: String? = nil,
        cursorQuestionType: String? = nil,
        cursorId: Int? = nil,
        size: Int = 10
    ) {
        if cursorId != nil, hasNextPageMap[categoryUUID] == false {
            return
        }
        
        basicProvider.request(.getBasic(
            categoryId: categoryId,
            cursorCreatedAt: cursorCreatedAt,
            cursorQuestionType: cursorQuestionType,
            cursorId: cursorId,
            size: size
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(QuestionBasicListResponse.self, from: response.data)
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.questionListMap[categoryUUID] = decodedData.result.values
                        } else {
                            // 다음 페이지 -> append
                            var existingList = self.questionListMap[categoryUUID] ?? []
                            existingList.append(contentsOf: decodedData.result.values)
                            self.questionListMap[categoryUUID] = existingList
                        }
                        self.hasNextPageMap[categoryUUID] = decodedData.result.hasNext
                    }
                } catch {
                    print("GetQuestionBasic 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("기본 질문 리스트를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetQuestionBasic API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("기본 질문 리스트를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func fetchBasicListsSearch(
        categoryUUID: UUID,
        categoryId: Int,
        keyword: String,
        cursorCreatedAt: String? = nil,
        cursorQuestionType: String? = nil,
        cursorId: Int? = nil,
        size: Int = 10
    ) {
        if cursorId != nil, searchHasNextPageMap[categoryUUID] == false {
            return
        }
        
        basicProvider.request(.getBasicSearch(
            categoryId: categoryId,
            keyword: keyword,
            cursorCreatedAt: cursorCreatedAt,
            cursorQuestionType: cursorQuestionType,
            cursorId: cursorId,
            size: size
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(QuestionBasicListResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.searchQuestionListMap[categoryUUID] = result.values
                        } else {
                            // 다음 페이지 -> append
                            var existingList = self.searchQuestionListMap[categoryUUID] ?? []
                            existingList.append(contentsOf: result.values)
                            self.searchQuestionListMap[categoryUUID] = existingList
                        }
                        self.searchHasNextPageMap[categoryUUID] = result.hasNext
                    }
                } catch {
                    print("GetQuestionBasicSearch 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("검색된 기본 질문 리스트를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetQuestionBasicSearch 디코더 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("검색된 기본 질문 리스트를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func fetchFixedBasic(fixedData: FixedData) {
        basicProvider.request(.postFixed(fixedData: fixedData)) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try JSONDecoder().decode(QuestionFixedResponse.self, from: response.data)
                } catch {
                    print("PostFixed 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("고정 질문을 설정하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PostFixed API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("고정 질문을 설정하지 못했습니다.")
                }
            }
        }
    }
    
    func fetchRandomBasic(randomData: RandomData) {
        basicProvider.request(.postRandom(randomData: randomData)) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try JSONDecoder().decode(QuestionFixedResponse.self, from: response.data)
                } catch {
                    print("PostRandom 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("랜덤 질문을 설정하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PostRandom API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("랜덤 질문을 설정하지 못했습니다.")
                }
            }
        }
    }
    
    func fetchOfficialSave(questionId: Int, selectedQuestionType: String) {
        basicProvider.request(.postOfficialSave(questionId: questionId, selectedQuestionType: selectedQuestionType)) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try JSONDecoder().decode(QuestionFixedResponse.self, from: response.data)
                    
                    // questionListMap 수정
                    for key in self.questionListMap.keys {
                        if let arr = self.questionListMap[key] {
                            self.questionListMap[key] = arr.map { item in
                                var newItem = item
                                if item.id == questionId {
                                    newItem.savedStatus = "SAVED"
                                }
                                return newItem
                            }
                        }
                    }
                    
                    // searchQuestionListMap 수정
                    for key in self.searchQuestionListMap.keys {
                        if let arr = self.searchQuestionListMap[key] {
                            self.searchQuestionListMap[key] = arr.map { item in
                                var newItem = item
                                if item.id == questionId {
                                    newItem.savedStatus = "SAVED"
                                }
                                return newItem
                            }
                        }
                    }
                } catch {
                    print("PostOfficialSave 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("질문을 저장하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PostOfficialSave 디코더 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("질문을 저장하지 못했습니다.")
                }
            }
        }
    }
}
