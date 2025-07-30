//
//  MyHomeViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/27/25.
//

import Foundation
import Moya

class MyHomeViewModel: ObservableObject {
    // MARK: - Properties
    // fetchMyHome
    var username: String = ""
    var nickname: String = ""
    var followerCount: String = "0"
    var followingCount: String = "0"
    var postCount: String = "0"
    var profileImageURL: String = ""
    
    // fetchMyPosts
    @Published var postListMap: [MyHomePostValue] = []
    @Published var hasNextPageMap: [Bool] = []
    
    private let memberProvider = APIManager.shared.createProvider(for: MemberRouter.self)
    
    // MARK: - Functions
    func fetchMyHome() {
        memberProvider.request(.getMyhome) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(MyHomeResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    self.username = result.username
                    self.nickname = result.nickname
                    self.followerCount = result.followerCount
                    self.followingCount = result.followingCount
                    self.postCount = result.postCount
                    self.profileImageURL = result.profileImgDTO.imageUrl
                } catch {
                    print("GetMyHome 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("GetMyHome 오류: \(error)")
            }
        }
    }
    
    func fetchMyPosts(
        cursorId: Int? = nil,
        size: Int? = 10
    ) {
        memberProvider.request(.getMyhomePosts(cursorId: cursorId, size: size)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(MyHomePostResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    
                }
            }
        }
    }
}
