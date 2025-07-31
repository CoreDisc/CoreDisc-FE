//
//  UserHomeViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 8/1/25.
//

import Foundation
import Moya

class UserHomeViewModel: ObservableObject {
    // MARK: - Properties
    // fetchUserHome
    @Published var memberId: Int = 0
    @Published var username: String = ""
    @Published var nickname: String = ""
    @Published var followerCount: String = "0"
    @Published var followingCount: String = "0"
    @Published var postCount: String = "0"
    @Published var isFollowing: Bool = false
    @Published var profileImageURL: String = ""
    
    // fetchUserPosts
    @Published var postList: [MyHomePostValue] = []
    @Published var hasNextPage: Bool = false
    
    private let memberProvider = APIManager.shared.createProvider(for: MemberRouter.self)
    private let followProvider = APIManager.shared.createProvider(for: FollowRouter.self)
    
    // MARK: - Functions
    func fetchUserHome(username: String) {
        memberProvider.request(.getMyhomeTargetUsername(targetUsername: username)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(UserHomeResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    self.memberId = result.memberId
                    self.username = result.username
                    self.nickname = result.nickname
                    self.followerCount = result.followerCount
                    self.followingCount = result.followingCount
                    self.postCount = result.postCount
                    self.isFollowing = result.isFollowing
                    self.profileImageURL = result.profileImgDTO.imageUrl
                } catch {
                    print("GetUserHome 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("GetUserHome 오류: \(error)")
            }
        }
    }
    
    func fetchFollow(targetId: Int, completion: (() -> Void)? = nil) {
        followProvider.request(.postFollow(targetId: targetId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(FollowResponse.self, from: response.data)
                    completion?()
                } catch {
                    print("PostFollow 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("PostFollow API 오류: \(error)")
            }
        }
    }
    
    func fetchUnfollow(targetId: Int, completion: (() -> Void)? = nil) {
        followProvider.request(.deleteFollowings(targetId: targetId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(UnfollowResponse.self, from: response.data)
                    completion?()
                } catch {
                    print("DeleteFollowings 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("DeleteFollowings API 오류: \(error)")
            }
        }
    }
}
