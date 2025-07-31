//
//  CategoryType.swift
//  CoreDisc
//
//  Created by 김미주 on 7/29/25.
//

import Foundation
import SwiftUI

enum QuestionCategoryType: String, CaseIterable {
    case 취향, 라이프스타일, 인간관계, 자기계발, 건강, 문화, 감정, 취미, 꿈, 기타
    
    var startColor: Color {
        switch self {
        case .취향: return .yellow1
        case .라이프스타일: return .blue1
        case .인간관계: return .purple1
        case .자기계발: return .pink1
        case .건강: return .lavender1
        case .문화: return .mint1
        case .감정: return .orange1
        case .취미: return .red1
        case .꿈: return .navy1
        case .기타: return .gray1
        }
    }
    
    var endColor: Color {
        switch self {
        case .취향: return .yellow2
        case .라이프스타일: return .blue2
        case .인간관계: return .purple2
        case .자기계발: return .pink2
        case .건강: return .lavender2
        case .문화: return .mint2
        case .감정: return .orange2
        case .취미: return .red2
        case .꿈: return .navy2
        case .기타: return .gray2
        }
    }
}
