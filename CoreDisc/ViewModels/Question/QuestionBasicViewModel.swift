//
//  QuestionBasicViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/13/25.
//

import Foundation
import SwiftUI

class QuesitonBasicViewModel: ObservableObject {
    @Published var categoryItem: [QuestionBasicCategoryModel] = []
    @Published var questionListMap: [UUID: [QuestionBasicListValue]] = [:]
    @Published var hasNextPageMap: [UUID: Bool] = [:]

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
    
    func fetchFixedBasic(fixedData: FixedData) {
        basicProvider.request(.postFixed(fixedData: fixedData)) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try JSONDecoder().decode(QuestionFixedResponse.self, from: response.data)
                } catch {
                    print("PostFixed 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("기본 질문을 설정하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PostFixed API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("기본 질문을 설정하지 못했습니다.")
                }
            }
        }
    }
}
