//
//  MyhomeRoute.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import Foundation

enum MyhomeRoute: Hashable {
    case home
    case core
    case edit
    case post(postId: Int)
    
    case calendar
    
    case setting
    case account
    case block
    case notification
    
    case user(userId: Int)
}
