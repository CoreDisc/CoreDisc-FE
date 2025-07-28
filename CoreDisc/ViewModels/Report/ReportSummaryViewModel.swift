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
    
    var ExtraDisc: [ExtraDiscModel] = [
        .init(text: "7월은 집에서 가장 많은 시간을 보냈네요. 정말 덥고 습하고 절대 밖으로 나가지 않았네요 에어컨이 없으면 살 수가 없을 지경입니다 아이스크림을 하루에 3개씩 먹고 있어요", date: "7/1"),
        .init(text: "날이 너무 습해서 이불도 눅눅하고 창문 열면 바람도 안 들어오고 선풍기만 돌려대니까 괜히 짜증만 늘어요. 그래서 하루 종일 아무것도 안 하고 가만히 누워만 있었어요", date: "7/2"),
        .init(text: "7월은 집에서 가장 많은  정말 덥고 습하고 절대 밖으로 나가지 않았네요 에어컨이 없으면 살 수가 없을 지경입니다 아이스크림을 하루에 3개씩 먹고 있어요", date: "7/4"),
        .init(text: "날이 너무 습해서 이불도 눅눅하고면 바람도 안 들어오고 선풍기만 돌려대니까 괜히 짜증만 늘어요. 그래서 하루 종일 아무것도 안 하고 가만히 누워만 있었어요", date: "7/5"),
        .init(text: "오늘은 그래도 조금 선선해서 산책을 다녀왔어요. 그래도 아직은 덥긴 덥네요", date: "7/6")
    ]
}
