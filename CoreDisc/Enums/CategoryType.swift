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
    case meal
    case sleep
    case hobby
    case place
    case feeling
    case leisure
    case other
    
    static var allCases: [CategoryType] {
        return [.all, .favorite, .meal, .sleep, .hobby, .place, .feeling, .leisure, .other]
    }
    
    var title: Text {
        switch self {
        case .all: Text("All")
        case .favorite: Text("즐겨찾기")
        case .meal: Text("식사")
        case .sleep: Text("수면")
        case .hobby: Text("취미")
        case .place: Text("장소")
        case .feeling: Text("기분")
        case .leisure: Text("여가")
        case .other: Text("기타")
        }
    }
    
    var style: CategoryStyle {
        switch self {
        case .all: .all
        case .favorite: .favorite
        default: .normal
        }
    }
    
    
    var color: LinearGradient {
        switch self {
        case .meal: LinearGradient(
            colors: [.yellow1, .yellow2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .sleep: LinearGradient(
            colors: [.blue1, .blue2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .hobby: LinearGradient(
            colors: [.purple1, .purple2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .place: LinearGradient(
            colors: [.pink1, .pink2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .feeling: LinearGradient(
            colors: [.lavender1, .lavender2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .leisure: LinearGradient(
            colors: [.mint1, .mint2],
            startPoint: .leading,
            endPoint: .trailing
        )
        case .other: LinearGradient(
            colors: [.orange1, .orange2],
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
    case favorite
    case normal
}

