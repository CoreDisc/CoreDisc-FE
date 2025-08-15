//
//  SelectiveDiaryType.swift
//  CoreDisc
//
//  Created by 김미주 on 8/13/25.
//

import Foundation

protocol DiaryDisplayable {
    var displayName: String { get }
}

enum DiaryWhat: String, Codable, DiaryDisplayable {
    case WORK, STUDY, EXERCISE, REST, SLEEP, HOBBY
    case UNKNOWN
    
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = DiaryWhat(rawValue: raw) ?? .UNKNOWN
    }
    
    var displayName: String {
        switch self {
        case .WORK: return "일"
        case .STUDY: return "공부"
        case .EXERCISE: return "운동"
        case .REST: return "휴식"
        case .SLEEP: return "수면"
        case .HOBBY: return "취미"
        case .UNKNOWN: return "알 수 없음"
        }
    }
}

enum DiaryWhere: String, Codable, DiaryDisplayable {
    case HOME, COMPANY, SCHOOL, CAFE, OUTDOOR, ON_THE_MOVE
    case UNKNOWN
    
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = DiaryWhere(rawValue: raw) ?? .UNKNOWN
    }
    
    var displayName: String {
        switch self {
        case .HOME: return "집"
        case .COMPANY: return "회사"
        case .SCHOOL: return "학교"
        case .CAFE: return "카페"
        case .OUTDOOR: return "야외"
        case .ON_THE_MOVE: return "이동 중"
        case .UNKNOWN: return "알 수 없음"
        }
    }
}

enum DiaryWho: String, Codable, DiaryDisplayable {
    case ALONE, FRIEND, FAMILY, COLLEAGUE, LOVER, PET
    case UNKNOWN
    
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = DiaryWho(rawValue: raw) ?? .UNKNOWN
    }
    
    var displayName: String {
        switch self {
        case .ALONE: return "혼자"
        case .FRIEND: return "친구"
        case .FAMILY: return "가족"
        case .COLLEAGUE: return "동료"
        case .LOVER: return "연인"
        case .PET: return "반려동물"
        case .UNKNOWN: return "알 수 없음"
        }
    }
}
