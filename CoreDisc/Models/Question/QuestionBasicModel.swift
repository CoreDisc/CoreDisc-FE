//
//  QuestionBasicModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/13/25.
//

import Foundation
import SwiftUI

struct QuestionBasicCategoryModel: Identifiable {
    let id = UUID()
    let title: String
    let startColor: Color
    let endColor: Color
}
