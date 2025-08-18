//
//  DiscResponse.swift
//  CoreDisc
//
//  Created by 정서영 on 8/14/25.
//

struct GetDiscResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: GetDiscResult?
}

struct GetDiscResult: Decodable {
    let totalDiscCount: Int
    let discs: [DiscData]
}

struct DiscData: Decodable {
    let id: Int
    let year: Int
    let month: Int
    let coverColor: String
    let hasCoverImage: Bool
    let coverImageUrl: String?
}

struct DiscItemData: Identifiable {
    let id: Int
    let year: Int
    let month: Int
    let dateLabel: String
    let imageUrl: String?
    let localImageName: String?
}

struct ColorChangeResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ColorChangeResult?
}

struct ColorChangeResult: Decodable {
    let id: Int
    let year: Int
    let month: Int
    let coverColor: String
    let hasCoverImage: Bool
    let coverImageUrl: String?
}

struct ChangeDiscImgResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ChangeDiscImgResult?
}

struct ChangeDiscImgResult: Decodable {
    let id: Int
    let year: Int
    let month: Int
    let coverColor: String
    let hasCoverImage: Bool
    let coverImageUrl: String?
}

