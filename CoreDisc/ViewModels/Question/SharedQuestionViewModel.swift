//
//  SharedQuestionViewModel.swift
//  CoreDisc
//
//  Created by 이채은 on 8/15/25.
//

import Foundation
import Moya

class SharedQuestionViewModel: ObservableObject {
    @Published var mySharedQuestionCnt: Int = 0
    @Published var mySharedQuestions: [SharedQuestion] = []
    @Published var hasNext: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let provider = APIManager.shared.createProvider(for: QuestionRouter.self)
    private var lastCursorId: Int? = nil
    
    // 공유 질문 목록 가져오기
    func fetchMySharedQuestions(cursorId: Int? = nil, size: Int = 10) {
        guard !isLoading else { return }
        isLoading = true
        
        provider.request(.getOfficialMine(cursorId: cursorId, size: size)) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(SharedQuestionResponse.self, from: response.data)
                    
                    DispatchQueue.main.async {
                        self.mySharedQuestionCnt = decoded.result.mySharedQuestionCnt ?? self.mySharedQuestions.count
                        
                        if let list = decoded.result.mySharedQuestionList {
                            if cursorId == nil {
                                self.mySharedQuestions = list.values
                            } else {
                                self.mySharedQuestions.append(contentsOf: list.values)
                            }
                            self.hasNext = list.hasNext
                        } else if let values = decoded.result.values {
                            if cursorId == nil {
                                self.mySharedQuestions = values
                            } else {
                                self.mySharedQuestions.append(contentsOf: values)
                            }
                            self.hasNext = decoded.result.hasNext ?? false
                        }
                        
                        self.lastCursorId = self.mySharedQuestions.last?.id
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "데이터를 불러오는 중 오류가 발생했습니다."
                        ToastManager.shared.show("데이터를 불러오는 중 오류가 발생했습니다.")
                    }
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    self.errorMessage = "데이터를 불러오는 중 오류가 발생했습니다."
                    ToastManager.shared.show("데이터를 불러오는 중 오류가 발생했습니다.")
                }
            }
        }
    }
    
    // 공유 질문 작성
    func shareOfficialQuestion(categoryIds: [Int], question: String, completion: @escaping (Bool) -> Void) {
        let data = OfficialPersonalData(categoryIdList: categoryIds, question: question)
        isLoading = true
        
        provider.request(.postOfficial(officialData: data)) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(ShareOfficialResponse.self, from: response.data)
                    if decoded.isSuccess {
                        let newQuestion = SharedQuestion(
                            id: decoded.result.id,
                            categories: categoryIds.map { SharedCategory(categoryId: $0, categoryName: "") },
                            question: question,
                            sharedCount: 0,
                            createdAt: decoded.result.createdAt
                        )
                        DispatchQueue.main.async {
                            // 즉시 UI에 반영
                            self.mySharedQuestions.insert(newQuestion, at: 0)
                            self.mySharedQuestionCnt += 1
                            ToastManager.shared.show("질문이 공유되었습니다.")
                            completion(true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            ToastManager.shared.show("질문 공유에 실패했습니다.")
                            completion(false)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        ToastManager.shared.show("질문 공유에 실패했습니다.")
                        completion(false)
                    }
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    ToastManager.shared.show("네트워크 오류가 발생했습니다.")
                    completion(false)
                }
            }
        }
    }
}
