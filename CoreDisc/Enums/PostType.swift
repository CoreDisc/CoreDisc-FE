//
//  PostType.swift
//  CoreDisc
//
//  Created by 김미주 on 8/20/25.
//

import Foundation

enum PostPublicityType: String, Codable {
    case OFFICIAL = "OFFICIAL"
    case CIRCLE = "CIRCLE"
}

enum PostFeedType: String, Codable {
    case ALL = "ALL"
    case CORE = "CORE"
}

public enum PostDiaryWho: String, Codable, CaseIterable {
    case ALONE // 혼자
    case FRIEND // 친구
    case FAMILY // 가족
    case COLLEAGUE // 동료
    case LOVER // 연인
    case PET // 반려동물
}

public enum PostDiaryWhere: String, Codable, CaseIterable {
    case HOME // 집
    case COMPANY // 회사
    case SCHOOL // 학교
    case CAFE // 카페
    case OUTDOOR // 야외
    case ON_THE_MOVE // 이동 중
}

public enum PostDiaryWhat: String, Codable, CaseIterable {
    case WORK // 일
    case STUDY // 공부
    case EXERCISE // 운동
    case REST // 휴식
    case SLEEP // 수면
    case HOBBY // 취미
}

enum PostStatus: String, Codable {
    case TEMP
    case PUBLISHED
}

// 오늘의 질문 타입(랜덤, 선택)
enum TodayQuestionType: Codable {
    case FIXED
    case RANDOM
}

// 게시글 타입
enum QuestionType: String, Decodable {
    case PERSONAL
    case OFFICIAL
}

// 게시글 답변 타입(글/그림)
enum AnswerType: String, Codable {
    case TEXT
    case IMAGE
}
