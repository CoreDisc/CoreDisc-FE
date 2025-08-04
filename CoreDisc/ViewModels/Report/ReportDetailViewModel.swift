//
//  ReportDetailViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 7/29/25.
//

import SwiftUI

@Observable
class ReportDetailViewModel: ObservableObject {
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
    
    var TotalDiscItem: [TotalDiscModel] = [
        .init(question: "1오늘 먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "fixed"),
        .init(question: "오2늘 먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "random"),
        .init(question: "오늘3 먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "fixed"),
        .init(question: "오늘 4먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "random"),
        .init(question: "오늘 먹5은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "random"),
        .init(question: "오늘 먹은6 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "fixed"),
        .init(question: "오늘 먹은 7것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "fixed"),
        .init(question: "오늘 먹은 것89 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "random"),
        .init(question: "오늘 먹은 것 중0에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "fixed"),
        .init(question: "오늘 먹은 것 중에0 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "random"),
        .init(question: "오늘 먹은 것 중에 3제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "fixed"),
        .init(question: "오늘 먹은 것 중에 제25일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "fixed"),
        .init(question: "오늘 먹은 것 중에 제일 7맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "random"),
        .init(question: "오늘 먹은 것 중에 제일 맛58있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "random"),
        .init(question: "오늘 먹은 것 중에 제일 맛있4었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.ㄴㅇ눈", category: "random"),
        .init(question: "오늘 먹은 것 중에 제일 맛있었23던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "fixed"),
        .init(question: "오늘 먹은 것 중에 제일 맛있었던 14건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "fixed"),
        .init(question: "오늘 먹은 것 중에 제일 맛있었던 건 21뭐였어? 그 음식에 대해 자세히 말해줘..", category: "fixed"),
        .init(question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐14였어? 그 음식에 대해 자세히 말해줘.", category: "random"),
        .init(question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐였52어? 그 음식에 대해 자세히 말해줘.", category: "fixed"),
        .init(question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐였어? 그 음식에 대해 자세히 말해줘.", category: "fixed"),
        .init(question: "오늘 먹은 것 중에 제일 맛있었던 건 뭐였어?65 그 음식에 대해 자세히 말해줘.", category: "random"),
    ]
}

class DiscViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    
    let itemsPerPage = 6
    private let reportVM = ReportDetailViewModel()
    
    var discItems: [TotalDiscModel] {
        reportVM.TotalDiscItem
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
