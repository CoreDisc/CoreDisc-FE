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
        
        let server: [String: CategoryType] = [
            "전체": .all,
            "취향": .taste,
            "라이프스타일": .lifeStyle,
            "관계": .relationship,
            "자기계발": .selfImprovement,
            "건강": .health,
            "문화": .culture,
            "감정": .feeling,
            "취미": .hobby,
            "꿈": .dream
        ]
        let type = server[dto.name] ?? .other
        
        self.startColor = type.startColor
        self.endColor = type.endColor
    }
}
