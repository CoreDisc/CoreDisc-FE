//
//  QuestionBasicModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/13/25.
//

import Foundation
import SwiftUI

struct QuestionBasicCategoryModel: Identifiable {
    let id = UUID()
    let categoryId: Int
    let title: String
    let count: Int
    let startColor: Color
    let endColor: Color
    
    init(from dto: QuestionCategoriesResult) {
        self.categoryId = dto.id
        self.title = dto.name
        self.count = dto.count
        
        let type = QuestionCategoryType(rawValue: dto.name) ?? .기타
        self.startColor = type.startColor
        self.endColor = type.endColor
    }
}
