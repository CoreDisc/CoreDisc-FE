//
//  ReportDetailViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 7/29/25.
//

import SwiftUI

@Observable
class ReportDetailViewModel {
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
