//
//  CoreQuestionsViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 8/16/25.
//

import Foundation

class CoreQuestionsViewModel: ObservableObject {
    // MARK: - Properties
    @Published var questionList: [Int: [CoreQuestionValue]] = [:]
    @Published var hasNextList: [Int: Bool] = [:]
    
    private let provider = APIManager.shared.createProvider(for: MemberRouter.self)

    // MARK: - Functions - API
    func fetchCoreQuestions(
        categoryId: Int,
        cursorCreatedAt: String? = nil,
        cursorQuestionType: String? = nil,
        cursorId: Int? = nil,
        size: Int? = 10
    ) {
        provider.request(.getMyhomeQuestion(
            categoryId: categoryId,
            cursorCreatedAt: cursorCreatedAt,
            cursorQuestionType: cursorQuestionType,
            cursorId: cursorId,
            size: size
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(CoreQuestionResponse.self, from: response.data)
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.questionList[categoryId] = decodedData.result.values
                        } else {
                            // 다음 페이지 -> append
                            var list = self.questionList[categoryId] ?? []
                            list.append(contentsOf: decodedData.result.values)
                            self.questionList[categoryId] = list
                        }
                        self.hasNextList[categoryId] = decodedData.result.hasNext
                    }
                }catch {
                    print("GetMyHomeQuestion 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("코어질문을 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetMyHomeQuestion 디코더 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("코어질문을 불러오지 못했습니다.")
                }
            }
        }
    }
}
