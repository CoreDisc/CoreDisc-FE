//
//  NavigationRouter.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class NavigationRouter<Route: Hashable> {
    var path = NavigationPath()
    
    // 추가
    func push(_ route: Route) {
        path.append(route)
    }
    
    // 마지막 화면 제거
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // 초기화
    func reset() {
        path = NavigationPath()
    }
}
