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
                }
            case .failure(let error):
                print("GetQuestionCategories API 오류: \(error)")
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
                }
            case .failure(let error):
                print("GetQuestionBasic API 오류: \(error)")
            }
        }
    }
}
