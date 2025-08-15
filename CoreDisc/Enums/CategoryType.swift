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
        return [.all, .taste, .lifeStyle, .relationship, .selfImprovement, .health, .culture, .feeling, .hobby, .dream, .other]
    }
    
    var id: Int {
        switch self {
        case .taste: return 1
        case .lifeStyle: return 2
        case .relationship: return 3
        case .selfImprovement: return 4
        case .health: return 5
        case .culture: return 6
        case .feeling: return 7
        case .hobby: return 8
        case .dream: return 9
        case .other: return 10
        case .all: return 0
        }
    }
    
    static func fromId(_ id: Int) -> CategoryType? {
            switch id {
            case 1: return .taste
            case 2: return .lifeStyle
            case 3: return .relationship
            case 4: return .selfImprovement
            case 5: return .health
            case 6: return .culture
            case 7: return .feeling
            case 8: return .hobby
            case 9: return .dream
            case 10: return .other
            default: return nil
            }
        }
    
    var title: String {
        switch self {
        case .all: "All"
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

