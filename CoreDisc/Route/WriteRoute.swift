//
//  WriteRoute.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import Foundation

enum WriteRoute: Hashable {
    case answer
    case select(postId: Int, isCore: Bool)
    case summary(postId: Int, selectedWho: DiaryWho, selectedWhere: DiaryWhere, selectedWhat: DiaryWhat, selectedMore: DiaryMore, selectedString: String, isCore: Bool)
}
