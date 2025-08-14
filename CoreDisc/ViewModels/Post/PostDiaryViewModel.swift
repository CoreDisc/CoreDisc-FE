//
//  PostDiaryViewModel.swift
//  CoreDisc
//
//  Created by 신연주 on 8/15/25.
//

import Foundation
import SwiftUI

class PostDiaryViewModel: ObservableObject {
    private let provider = APIManager.shared.createProvider(for: PostRouter.self)
}

