//
//  ReportDetailViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 7/29/25.
//

import SwiftUI
import Moya

class ReportDetailViewModel: ObservableObject {
    
    @Published var TotalDiscItem: [TotalDiscModel] = []{
        didSet {
            DiscCount = TotalDiscItem.count
        }
    }
    @Published var DiscCount: Int = 0
    @Published var MostQuestionItem: [MostSelectedQuestion] = []
    @Published var PeakTimeImage: String = ""
    @Published var hasPreviousReport: Bool = false
    @Published var hasNextReport: Bool = false

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
                            self.hasNextReport = resultData.hasNextReport
                            self.hasPreviousReport = resultData.hasPreviousReport
                            self.TotalDiscItem = (fixedModels + randomModels).shuffled()
                            
                            if !resultData.allOneCount {
                                var list = resultData.mostSelectedQuestions ?? []
                                list.insert(MostSelectedQuestion(questionContent: "", selectedCount: nil), at: 0)
                                list.append(MostSelectedQuestion(questionContent: "", selectedCount: nil))
                                self.MostQuestionItem = list
                            } else {
                                self.MostQuestionItem = [
                                    MostSelectedQuestion(questionContent: "", selectedCount: nil),
                                    MostSelectedQuestion(
                                        questionContent: "매일 다른 랜덤 질문과 함께했습니다.",
                                        selectedCount: nil
                                    ),
                                    MostSelectedQuestion(questionContent: "", selectedCount: nil)
                                ]
                            }
                            
                            switch resultData.peakTimeZone{
                            case "DAWN" : self.PeakTimeImage = "img_dawn"
                            case "MORNING" : self.PeakTimeImage = "img_morning"
                            case "DAY" : self.PeakTimeImage = "img_day"
                            case "AFTERNOON" : self.PeakTimeImage = "img_afternoon"
                            case "EVENING" : self.PeakTimeImage = "img_evening"
                            default:
                                self.PeakTimeImage = "img_day"
                            }
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
