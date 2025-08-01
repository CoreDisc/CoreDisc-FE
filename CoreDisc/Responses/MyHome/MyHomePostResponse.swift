//
//  MyHomePostResponse.swift
//  CoreDisc
//
//  Created by 김미주 on 7/29/25.
//

import Foundation

struct MyHomePostResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MyHomePostResult
}

struct MyHomePostResult: Decodable {
    let values: [MyHomePostValue?]
    let hasNext: Bool
}

struct MyHomePostValue: Decodable {
    let postId: Int
    let postImageThumbnailDTO: PostImageThumbnailDTO?
    let postTextThumbnailDTO: PostTextThumbnailDTO?
}

struct PostImageThumbnailDTO: Decodable {
    let thumbnailUrl: String
}

struct PostTextThumbnailDTO: Decodable {
    let content: String
}
