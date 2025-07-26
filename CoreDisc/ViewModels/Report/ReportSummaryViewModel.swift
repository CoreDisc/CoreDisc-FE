//
//  ReportSummaryViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 7/26/25.
//

import Foundation
import SwiftUI

@Observable
class ReportSummaryViewModel {
    var SummaryQuest: [ReportSummaryModel] = [
        .init(question: "누구와 가장 많이 있었을까요?", answer: "5월은 친구와 가장 많은 시간을 보냈어요.", freq: "총 17회"),
        .init(question: "어디에 가장 많이 있었을까요?", answer: "5월은 집에서 가장 많은 시간을 보냈어요.", freq: "총 21회"),
        .init(question: "무엇을 가장 많이 했을까요?", answer: "5월은 여행으로 가장 많은 시간을 보냈어요.", freq: "총 14회"),
    ]
}
