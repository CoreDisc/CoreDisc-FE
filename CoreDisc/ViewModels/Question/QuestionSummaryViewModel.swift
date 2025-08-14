//
//  QuestionSummaryViewModel.swift
//  CoreDisc
//
//  Created by 이채은 on 8/15/25.
//

import Foundation
import Moya

final class QuestionSummaryViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let provider = APIManager.shared.createProvider(for: QuestionRouter.self)
    
    /// 내가 작성한 질문 저장 (개인)
    func savePersonalQuestion(categoryIds: [Int], question: String, completion: (() -> Void)? = nil) {
        let data = OfficialPersonalData(categoryIdList: categoryIds, question: question)
        isLoading = true
        
        provider.request(.postPersonal(personalData: data)) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let response):
                if let httpResponse = response.response {
                    print("savePersonalQuestion status: \(httpResponse.statusCode)")
                }
                completion?()
                
            case .failure(let error):
                print("개인 질문 저장 API 오류: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = "질문 저장에 실패했습니다."
                    ToastManager.shared.show("질문 저장에 실패했습니다.")
                }
            }
        }
    }
    
    /// 내가 작성한 질문 공유 (공유 발행)
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
                        print("공유 질문 발행 성공: id=\(decoded.result.id)")
                        DispatchQueue.main.async {
                            ToastManager.shared.show("질문이 공유되었습니다.")
                        }
                        completion(true)
                    } else {
                        print("공유 질문 발행 실패: \(decoded.message)")
                        DispatchQueue.main.async {
                            self.errorMessage = decoded.message
                            ToastManager.shared.show("질문 공유에 실패했습니다.")
                        }
                        completion(false)
                    }
                } catch {
                    print("공유 질문 디코딩 오류: \(error)")
                    DispatchQueue.main.async {
                        self.errorMessage = "응답 처리 중 오류가 발생했습니다."
                        ToastManager.shared.show("질문 공유에 실패했습니다.")
                    }
                    completion(false)
                }
                
            case .failure(let error):
                print("공유 질문 API 오류: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = "네트워크 오류가 발생했습니다."
                    ToastManager.shared.show("질문 공유에 실패했습니다.")
                }
                completion(false)
            }
        }
    }

}
