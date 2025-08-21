//
//  QuestionListViewModel.swift
//  CoreDisc
//
//  Created by 이채은 on 8/15/25.
//

import Foundation
import SwiftUI
import Moya
class QuestionListViewModel: ObservableObject {
    @Published var questionListMap: [UUID: [QuestionListItem]] = [:]
    @Published var hasNextPageMap: [UUID: Bool] = [:]
    
    private let provider = APIManager.shared.createProvider(for: QuestionRouter.self)
    
    /// 내가 발행한 공유질문 리스트 조회
    func fetchOfficialMine(
        categoryUUID: UUID,
        categoryId: Int? = nil,
        cursorId: Int? = nil,
        size: Int = 10
    ) {
        if cursorId != nil, hasNextPageMap[categoryUUID] == false {
            return
        }
        
        let target: QuestionRouter
        if let categoryId = categoryId, categoryId != 0 {
            // 카테고리 필터 버전 API 호출
            target = .getOfficialMineByCategory(categoryId: categoryId, cursorId: cursorId, size: size)
        } else {
            // 전체 API 호출
            target = .getOfficialMine(cursorId: cursorId, size: size)
        }
        
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(QuestionListResponse.self, from: response.data)
                    if decoded.isSuccess {
                        DispatchQueue.main.async {
                            if cursorId == nil {
                                self.questionListMap[categoryUUID] = decoded.result.values
                            } else {
                                var existingList = self.questionListMap[categoryUUID] ?? []
                                existingList.append(contentsOf: decoded.result.values)
                                self.questionListMap[categoryUUID] = existingList
                            }
                            self.hasNextPageMap[categoryUUID] = decoded.result.hasNext
                        }
                    } else {
                        DispatchQueue.main.async {
                            ToastManager.shared.show(decoded.message)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        ToastManager.shared.show("질문 리스트를 불러오지 못했습니다.")
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    ToastManager.shared.show("질문 리스트를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func fetchOfficialSavedMine(
            categoryUUID: UUID,
            categoryId: Int? = nil,
            cursorId: Int? = nil,
            size: Int = 10
        ) {
            if cursorId != nil, hasNextPageMap[categoryUUID] == false {
                return
            }

            let target: QuestionRouter = .getOfficialSavedMine(
                categoryId: (categoryId != 0) ? categoryId : nil,
                cursorId: cursorId,   // → savedId 를 넣어야 함
                size: size
            )
            
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoded = try JSONDecoder().decode(QuestionListResponse.self, from: response.data)
                        if decoded.isSuccess {
                            DispatchQueue.main.async {
                                if cursorId == nil {
                                    self.questionListMap[categoryUUID] = decoded.result.values
                                } else {
                                    var existingList = self.questionListMap[categoryUUID] ?? []
                                    existingList.append(contentsOf: decoded.result.values)
                                    self.questionListMap[categoryUUID] = existingList
                                }
                                self.hasNextPageMap[categoryUUID] = decoded.result.hasNext
                            }
                        } else {
                            DispatchQueue.main.async {
                                ToastManager.shared.show(decoded.message)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            ToastManager.shared.show("질문 리스트를 불러오지 못했습니다.")
                        }
                    }
                case .failure:
                    DispatchQueue.main.async {
                        ToastManager.shared.show("질문 리스트를 불러오지 못했습니다.")
                    }
                }
            }
        }
    
    
    func deleteOfficialSaved(savedId: Int, completion: @escaping (Bool) -> Void) {
        provider.request(.deleteOfficial(savedId: savedId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(DeleteQuestionResponse.self, from: response.data)
                    if decoded.isSuccess {
                        DispatchQueue.main.async {
                            ToastManager.shared.show(decoded.result ?? "삭제되었습니다.")
                            completion(true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            ToastManager.shared.show(decoded.message)
                            completion(false)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        ToastManager.shared.show("삭제 처리에 실패했습니다.")
                        completion(false)
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    ToastManager.shared.show("네트워크 오류가 발생했습니다.")
                    completion(false)
                }
            }
        }
    }

    
    
}
