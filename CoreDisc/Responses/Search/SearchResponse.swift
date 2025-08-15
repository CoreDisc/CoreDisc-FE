//
//  SearchResponse.swift
//  CoreDisc
//
//  Created by 이채은 on 8/10/25.
//

import Foundation

struct RecentSearchResponse: Decodable {
    let isSuccess: Bool
    let code: String?
    let message: String?
    let result: RecentSearchResult
}

struct RecentSearchResult: Decodable {
    let values: [RecentSearchItem]
    let hasNext: Bool
}

struct RecentSearchItem: Decodable, Identifiable {
    let id: Int
    let keyword: String
    let searchedAt: String
}

struct DeleteMessageResponse: Decodable {
    let isSuccess: Bool
    let code: String?
    let message: String?
    let result: String?
}
