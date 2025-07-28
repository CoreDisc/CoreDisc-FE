//
//  Config.swift
//  CoreDisc
//
//  Created by 김미주 on 7/23/25.
//

import Foundation

// 앱 실행 시 Info.plist에서 "BASE_URL" 값을 가져와서 전역적으로 사용할 수 있도록 설정
enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist 없음")
        }
        return dict
    }()
    
    static let baseURL: String = {
        guard let baseURL = Config.infoDictionary["BASE_URL"] as? String else {
            fatalError()
        }
        return baseURL
    }()
}
