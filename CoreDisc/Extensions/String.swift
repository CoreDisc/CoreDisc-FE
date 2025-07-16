//
//  String.swift
//  CoreDisc
//
//  Created by 김미주 on 7/13/25.
//

import Foundation

// 글자 단위 줄바꿈
extension String {
    func splitCharacter() -> String {
        return self.split(separator: "").joined(separator: "\u{200B}")
    }
}
