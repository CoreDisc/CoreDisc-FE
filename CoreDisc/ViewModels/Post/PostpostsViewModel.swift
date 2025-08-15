//
//  PostpostsViewModel.swift
//  CoreDisc
//
//  Created by 신연주 on 8/15/25.
//

import Foundation
import SwiftUI
import Moya

class PostpostsViewModel: ObservableObject {
    private let postProvider = APIManager.shared.createProvider(for: PostRouter.self)
    
    @Published var lastResult: PostpostsResult?
    @Published var errorMessage: String?
    
    func postPosts(selectedDate: String) {
        postProvider.request(.postPosts(selectedDate: selectedDate)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(PostpostsResponse.self, from: response.data)
                    if decoded.isSuccess {
                        self.lastResult = decoded.result
                        print("POST 성공: postId=\(decoded.result.postId)")
                    } else {
                        self.errorMessage = "[\(decoded.code)] \(decoded.message)"
                        print("POST 실패: \(decoded.message)")
                    }
                } catch {
                    self.errorMessage = "디코딩 실패: \(error.localizedDescription)"
                    print("디코딩 실패:", error)
                }

            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("postPosts Api 연결 오류:", error)
            }
        }
    }
}
