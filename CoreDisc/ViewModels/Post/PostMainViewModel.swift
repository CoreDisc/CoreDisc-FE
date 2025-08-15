//
//  PostMainViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 8/13/25.
//

import Foundation

class PostMainViewModel: ObservableObject {
    @Published var postList: [PostMain] = []
    @Published var hasNextPage: Bool = false
    
    private let provider = APIManager.shared.createProvider(for: PostRouter.self)
    
    // MARK: - Functions
    func fetchPosts(
        feedType: String? = "ALL",
        cursor: Int? = nil,
        size: Int? = 10
    ) {
        provider.request(.getPosts(
            feedType: feedType,
            cursorId: cursor,
            size: size
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(PostMainResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        if cursor == nil {
                            // 첫 요청 -> 전체 초기화
                            self.postList = result.posts
                        } else {
                            // 다음 페이지 -> append
                            self.postList.append(contentsOf: result.posts)
                        }
                        self.hasNextPage = result.hasNext
                    }
                } catch {
                    print("GetPosts 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("게시글을 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetPosts API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("게시글을 불러오지 못했습니다.")
                }
            }
        }
    }
}
