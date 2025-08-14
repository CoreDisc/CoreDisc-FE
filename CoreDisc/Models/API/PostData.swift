//
//  PostData.swift
//  CoreDisc
//
//  Created by 김미주 on 7/25/25.
//

import Foundation

enum PostPublicityType: String, Codable {
    case OFFICIAL = "OFFICIAL"
    case PERSONAL = "PERSONAL"
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


// 게시글 발행
struct PostPublishData: Codable {
    let postId: Int?
    let publicity: PostPublicityType
    let selectiveDiary: SelectiveDiaryData
}

struct SelectiveDiaryData: Codable {
    let who: PostDiaryWho
    let `where`: PostDiaryWhere
    let what: PostDiaryWhat
    let detail: String?
}

// 게시글 피드 조회 (Pull 모델)
struct PostFeedData: Codable {
    let feedType: PostFeedType
    let cursor: Int
    let size: Int
}



