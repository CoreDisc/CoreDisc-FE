//
//  FollowersSheetViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/16/25.
//

import Foundation

class FollowSheetViewModel: ObservableObject {
    // MARK: - Properties
    // fetchFollowers
    @Published var followerList: [FollowerValues] = []
    @Published var followerHasNextPage: Bool = false
    @Published var followerCount: Int = 0
    
    private let followProvider = APIManager.shared.createProvider(for: FollowRouter.self)
    
    // MARK: - Functions
    func fetchFollowers(
        cursorId: Int? = nil,
        size: Int? = 10
    ) {
        followProvider.request(.getFollowers(cursorId: cursorId, size: size)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(FollowersResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.followerList = result.followerCursor.values
                        } else {
                            // 다음 페이지 -> append
                            self.followerList.append(contentsOf: result.followerCursor.values)
                        }
                        self.followerCount = result.totalCount
                        self.followerHasNextPage = result.followerCursor.hasNext
                    }
                } catch {
                    print("GetFollowers 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("GetFollowers API 오류: \(error)")
            }
        }
    }
}
