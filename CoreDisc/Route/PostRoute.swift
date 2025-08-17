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
    case user(userName: String)
    case myHome
}
