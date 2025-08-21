//
//  PostDiaryViewModel.swift
//  CoreDisc
//
//  Created by 신연주 on 8/15/25.
//

import Foundation
import SwiftUI

class PostDiaryViewModel: ObservableObject {
    private let postProvider = APIManager.shared.createProvider(for: PostRouter.self)
    
    // 게시글 작성 (선택일기)
    func fetchPublishPost(postId: Int, postData: PostPublishData) {
        postProvider.request(.putPublish(postId: postId, postPublishData: postData)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(PostDiaryResponse.self, from: response.data)
                    print("게시글 작성 성공: \(decodedData.message)")
                } catch {
                    print("PutPublish 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("게시글을 생성하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PutPublish API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("게시글을 생성하지 못했습니다.")
                }
            }
        }
    }
}

