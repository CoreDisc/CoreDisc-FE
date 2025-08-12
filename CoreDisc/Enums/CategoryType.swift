//
//  CategoryType.swift
//  CoreDisc
//
//  Created by 이채은 on 7/20/25.
//

import Foundation
import SwiftUI

enum CategoryType: CaseIterable {
    case all
    case favorite
    case taste
    case lifeStyle
    case relationship
    case selfImprovement
    case health
    case culture
    case feeling
    case hobby
    case dream
    case other
    
    static var allCases: [CategoryType] {
        return [.all, .favorite, .taste, .lifeStyle, .relationship, .selfImprovement, .health, .culture, .feeling, .hobby, .dream, .other]
    }
    
    var title: String {
        switch self {
        case .all: "All"
        case .favorite: "즐겨찾기"
        case .taste: "취향"
        case .lifeStyle: "라이프스타일"
        case .relationship: "인간관계"
        case .selfImprovement: "자기계발"
        case .health: "건강"
        case .culture: "문화"
        case .feeling: "감정"
        case .hobby: "취미"
        case .dream: "꿈"
        case .other: "기타"
        }
    }
    
    var style: CategoryStyle {
        switch self {
        case .all: .all
        default: .normal
        }
    }
    
    
    var color: LinearGradient {
        switch self {
        case .taste: LinearGradient(
            colors: [.yellow1, .yellow2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .lifeStyle: LinearGradient(
            colors: [.blue1, .blue2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .relationship: LinearGradient(
            colors: [.purple1, .purple2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .selfImprovement: LinearGradient(
            colors: [.pink1, .pink2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .health: LinearGradient(
            colors: [.lavender1, .lavender2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .culture: LinearGradient(
            colors: [.mint1, .mint2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .feeling: LinearGradient(
            colors: [.orange1, .orange2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .hobby: LinearGradient(
            colors: [.red1, .red2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .dream: LinearGradient(
            colors: [.navy1, .navy2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .other: LinearGradient(
            colors: [.gray700, .gray700],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .favorite: LinearGradient(
            colors: [.key, .gray700],
            startPoint: UnitPoint(x: 0, y: -0.3),
            endPoint: UnitPoint(x: 0, y: 1.5)
        )
        case .all: LinearGradient(
            colors: [.clear, .clear],
            startPoint: .zero,
            endPoint: .zero)
        }
    }
    
}

enum CategoryStyle {
    case all
    case normal
}

