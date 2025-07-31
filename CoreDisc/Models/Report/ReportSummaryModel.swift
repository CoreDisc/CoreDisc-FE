//
//  ReportSummaryModel.swift
//  CoreDisc
//
//  Created by 정서영 on 7/26/25.
//

import Foundation
import SwiftUI

struct ReportSummaryModel {
    let question: String
    let answer: String
    let freq: String
}

struct ExtraDiscModel: Identifiable {
    let id = UUID()
    let text: String
    let date: String
}
