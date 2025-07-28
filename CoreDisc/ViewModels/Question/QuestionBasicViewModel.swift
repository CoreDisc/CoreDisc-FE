//
//  QuestionBasicViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/13/25.
//

import Foundation
import SwiftUI

@Observable
class QuesitonBasicViewModel {
    var categoryItem: [QuestionBasicCategoryModel] = []
    
    private let categoriesProvider = APIManager.shared.createProvider(for: QuestionRouter.self)
    
    // MARK: - Functions
    func fetchCategories() {
        categoriesProvider.request(.getCategories) { result in
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
}
