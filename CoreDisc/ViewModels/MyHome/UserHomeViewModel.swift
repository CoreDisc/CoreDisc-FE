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
    @Published var blocked: Bool = false
    
    // fetchUserPosts
    @Published var postList: [MyHomePostValue] = []
    @Published var hasNextPage: Bool = false
    
    private let memberProvider = APIManager.shared.createProvider(for: MemberRouter.self)
    private let followProvider = APIManager.shared.createProvider(for: FollowRouter.self)
    private let blockProvider = APIManager.shared.createProvider(for: BlockRouter.self)
    
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
                    self.blocked = result.blocked
                } catch {
                    print("GetUserHome 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("GetUserHome 오류: \(error)")
            }
        }
    }
    
    func fetchUserPosts(
        targetUsername: String,
        cursorId: Int? = nil,
        size: Int? = 10
    ) {
        memberProvider.request(.getMyhomePostsTargetUsername(
            targetUsername: targetUsername,
            cursorId: cursorId,
            size: size)
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(MyHomePostResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        let validPosts = result.values.compactMap { $0 } // null 제거
                        
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.postList = validPosts
                        } else {
                            // 다음 페이지 -> append
                            self.postList.append(contentsOf: validPosts)
                        }
                        self.hasNextPage = result.hasNext
                    }
                } catch {
                    print("GetUserPosts 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("GetUserPosts API 오류: \(error)")
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
    
    func fetchBlock(targetId: Int, completion: (() -> Void)? = nil) {
        blockProvider.request(.postBlock(targetId: targetId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(BlockResponse.self, from: response.data)
                    completion?()
                } catch {
                    print("PostBlock 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("PostBlock API 오류: \(error)")
            }
        }
    }
    
    func fetchUnblock(targetId: Int, completion: (() -> Void)? = nil) {
        blockProvider.request(.deleteBlock(targetId: targetId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(UnblockResponse.self, from: response.data)
                    completion?()
                } catch {
                    print("DeleteBlock 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("DeleteBlock API 오류: \(error)")
            }
        }
    }
}
