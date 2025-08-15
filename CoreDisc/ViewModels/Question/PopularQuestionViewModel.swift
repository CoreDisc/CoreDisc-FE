//
//  PopularQuestionViewModel.swift
//  CoreDisc
//
//  Created by 이채은 on 8/15/25.
//

import Moya
import Foundation

final class PopularQuestionViewModel: ObservableObject {
    @Published var startDate: String = ""
    @Published var endDate: String = ""
    @Published var questions: [PopularQuestion] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let provider = APIManager.shared.createProvider(for: QuestionRouter.self)
    
    func fetchPopularQuestions(type: String = "OFFICIAL") {
        guard !isLoading else { return }
        isLoading = true
        
        provider.request(.getPopular(selectedQuestionType: type)) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(PopularQuestionResponse.self, from: response.data)
                    
                    if decoded.isSuccess {
                        DispatchQueue.main.async {
                            self.startDate = decoded.result.startDate
                            self.endDate = decoded.result.endDate
                            self.questions = decoded.result.popularQuestionList
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = decoded.message
                            ToastManager.shared.show(decoded.message)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "데이터를 불러오는 중 오류가 발생했습니다."
                        ToastManager.shared.show("데이터를 불러오는 중 오류가 발생했습니다.")
                    }
                }
                
            case .failure:
                DispatchQueue.main.async {
                    self.errorMessage = "네트워크 오류가 발생했습니다."
                    ToastManager.shared.show("네트워크 오류가 발생했습니다.")
                }
            }
        }
    }
}
