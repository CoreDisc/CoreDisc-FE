//
//  PostRoute.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import Foundation

enum PostRoute: Hashable {
    case home
    case search
    case notification
    case detail(postId: Int)
    
    // 댓글
    case user(userName: String)
    case myHome
    
    // 알림
    case write
    case questionMain
    
    //검색 결과
    case searchResult(query: String)
}
