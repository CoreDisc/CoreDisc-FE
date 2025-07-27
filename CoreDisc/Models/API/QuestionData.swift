//
//  QuestionData.swift
//  CoreDisc
//
//  Created by 김미주 on 7/24/25.
//

import Foundation

enum SelectedQuestionType: String, Codable {
    case DEFAULT = "DEFAULT" // 기본 질문
    case OFFICIAL = "OFFICIAL" // 발행된 공유 질문
    case PERSONAL = "PERSONAL" // 사용자 본인이 작성하여 저장한 질문
}

// 고정 질문 선택
struct FixedData: Codable {
    let selectedQuestionType: SelectedQuestionType
    let questionOrder: Int // 질문 순서 (위에서부터 1, 2, 3)
    let questionId: Int
}

// 랜덤 질문 선택
struct RandomData: Codable {
    let selectedQuestionType: SelectedQuestionType
    let questionId: Int
}

// 사용자가 작성한 커스텀 질문 공유하기, 사용자가 작성한 커스텀 질문 저장하기
struct OfficialPersonalData: Codable {
    let categoryIdList: [Int] // 최대 3개까지 선택 가능
    let question: String
}

// 작성하여 저장한 질문 수정하기
struct OfficialPersonalPatchData: Codable {
    let categoryIdList: [Int]?
    let question: String?
}
