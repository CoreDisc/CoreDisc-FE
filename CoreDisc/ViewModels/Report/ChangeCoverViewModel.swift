//
//  ChangeCoverViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 7/30/25.
//

import SwiftUI

@Observable
class ChangeCoverViewModel {
    var CoverList: [ChangeCoverModel] = [
            .init(img: .init(.imgOrangeCover)),
            .init(img: .init(.imgBlueCover)),
    ]
}
