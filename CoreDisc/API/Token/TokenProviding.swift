//
//  TokenProviding.swift
//  CoreDisc
//
//  Created by 김미주 on 7/24/25.
//

import Foundation

// 토큰을 제공/갱신하는 역할을 명시한 프로토콜
protocol TokenProviding {
    var accessToken: String? { get set }
    func refreshToken(completion: @escaping (String?, Error?) -> Void)
}
