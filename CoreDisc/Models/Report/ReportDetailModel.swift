//
//  ReportDetailModel.swift
//  CoreDisc
//
//  Created by 정서영 on 7/29/25.
//

import SwiftUI

struct RandomQuestionModel : Identifiable {
    let id = UUID()
    let question: String
    let freq: String
}

struct TotalDiscModel : Identifiable {
    let id = UUID()
    let question: String
    let category: String
}
