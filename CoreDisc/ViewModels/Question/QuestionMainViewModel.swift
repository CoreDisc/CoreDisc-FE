//
//  QuestionMainViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 8/1/25.
//

import Foundation
import SwiftUI
import Moya

class QuestionMainViewModel: ObservableObject {
    // MARK: - Properties
    @Published var selectedQuestions: [QuestionSelectedResult] = []

    private let mainProvider = APIManager.shared.createProvider(for: QuestionRouter.self)
    
    // MARK: - Functions
    func fetchSelected() {
        mainProvider.request(.getSelected) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(QuestionSelectedResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    self.selectedQuestions = result
                } catch {
                    print("GetSelected 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("선택된 질문을 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetSelected API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("선택된 질문을 불러오지 못했습니다.")
                }
            }
        }
    }
}
