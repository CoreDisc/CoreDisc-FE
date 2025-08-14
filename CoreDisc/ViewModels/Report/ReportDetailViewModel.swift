//
//  ReportDetailViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 7/29/25.
//

import SwiftUI
import Moya

class ReportDetailViewModel: ObservableObject {
    
    @Published var TotalDiscItem: [TotalDiscModel] = []
    
    private let ReportProvider = APIManager.shared.createProvider(for: ReportRouter.self)
    
    func getReport(year: Int, month: Int) {
        ReportProvider.request(.getMonthlyReport(year: year, month: month)){ result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(ReportResponse.self, from: response.data)
                    print("성공: \(decodedResponse)")
                    if let resultData = decodedResponse.result {
                        let fixedModels = resultData.fixedQuestions.map {
                            TotalDiscModel(question: $0.questionContent, category: "fixed")
                        }
                        
                        let randomModels = resultData.randomQuestions.map {
                            TotalDiscModel(question: $0.questionContent, category: "random")
                        }
                        
                        DispatchQueue.main.async {
                            self.TotalDiscItem = (fixedModels + randomModels).shuffled()
                        }
                    }

                } catch {
                    print("디코딩 실패 : \(error)")
                }
            case .failure(let error):
                print("네트워크 오류 : \(error)")
            }
        }
    }
    
    
    var RandomQuestion: [RandomQuestionModel] = [
        .init(question: "", freq: ""),
        .init(question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", freq: "총 18회"),
        .init(question: "오늘 하루 중에서 가장 기억에 남는 순간은 언제였어? 왜 그랬는지도 궁금해.", freq: "총 16회"),
        .init(question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐였어? 히 말해줘.", freq: "총 14회"),
        .init(question: "오늘 먹은 것 중에 제일 맛있었어? 그 음식에 대해 자세히 말해줘.", freq: "총 13회"),
        .init(question: "오늘 하루 중에서  남는 순간은 언제였어? 왜 그랬는지도 궁금해.", freq: "총 10회"),
        .init(question: "오늘 먹은 것 에 제일 맛있었던 건 뭐였어? 히 말해줘.", freq: "총 9회"),
        .init(question: "", freq: ""),
    ]
}

class DiscViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    
    let itemsPerPage = 6
    @ObservedObject var viewModel = ReportDetailViewModel()
    
    init(reportVM: ReportDetailViewModel) {
        self.viewModel = reportVM
    }
    
    var discItems: [TotalDiscModel] {
        viewModel.TotalDiscItem
    }
    
    var pagedItems: [TotalDiscModel] {
        let startIndex = currentPage * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, discItems.count)
        return Array(discItems[startIndex..<endIndex])
    }

    var hasNextPage: Bool {
        return (currentPage + 1) * itemsPerPage < discItems.count
    }
    
    var hasPreviousPage: Bool {
        return currentPage > 0
    }

    func nextPage() {
        if hasNextPage {
            currentPage += 1
        } else {
            print("마지막 페이지입니다.")
        }
    }
    
    func previousPage() {
        if hasPreviousPage {
            currentPage -= 1
        } else {
            print("첫 번째 페이지입니다.")
        }
    }
}
