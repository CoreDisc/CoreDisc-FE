//
//  QuestionBasicViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/13/25.
//

import Foundation
import SwiftUI

@Observable
class QuesitonBasicViewModel {
    let categoryItem: [QuestionBasicCategoryModel] = [
        .init(title: "식사", startColor: .yellow1, endColor: .yellow2),
        .init(title: "수면", startColor: .blue1, endColor: .blue2),
        .init(title: "취미", startColor: .purple1, endColor: .purple2),
        .init(title: "장소", startColor: .pink1, endColor: .pink2),
        .init(title: "기분", startColor: .lavender1, endColor: .lavender2),
        .init(title: "여가", startColor: .mint1, endColor: .mint2),
        .init(title: "기타", startColor: .orange1, endColor: .orange2),
    ]
}
