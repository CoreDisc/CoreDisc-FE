//
//  ChangeCoverViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 7/31/25.
//

import SwiftUI

@Observable
class ChangeCoverViewModel {
    var CoverList: [ChangeCoverModel] = [
        .init(color: "yellow", image: .init(.imgYellowCover)),
        .init(color: "blue", image: .init(.imgBlueCover)),
        .init(color: "purple", image: .init(.imgPurpleCover)),
        .init(color: "pink", image: .init(.imgPinkCover)),
        .init(color: "lavender", image: .init(.imgLavenderCover)),
        .init(color: "mint", image: .init(.imgMintCover)),
        .init(color: "orange", image: .init(.imgOrangeCover)),
        .init(color: "red", image: .init(.imgRedCover)),
        .init(color: "violet", image: .init(.imgVioletCover)),
        .init(color: "gray", image: .init(.imgGrayCover)),
    ]
}
