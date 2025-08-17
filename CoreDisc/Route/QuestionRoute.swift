//
//  QuestionRoute.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import Foundation

enum QuestionRoute: Hashable {
    case main
    
    case write
    case summary(questionId: Int?, selectedCategory: CategoryType, text: String)
    
    case basic
    
    case trending
    
    case shareNow
    case shareList
}
