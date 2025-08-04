//
//  FollowersSheetViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/16/25.
//

import Foundation

class FollowSheetViewModel: ObservableObject {
    // MARK: - Properties
    @Published var currentTargetUsername: String = ""

    // fetchFollowers
    @Published var followerList: [FollowerValues] = []
    @Published var followerHasNextPage: Bool = false
    @Published var followerCount: Int = 0
    
    // fetchFollowings
    @Published var followingList: [FollowingValues] = []
    @Published var followingHasNextPage: Bool = false
    @Published var followingCount: Int = 0
    
    // fetchUserFollowers
    @Published var userFollowerList: [UserFollowerValues] = []
    @Published var userFollowerHasNextPage: Bool = false
    @Published var userFollowerCount: Int = 0
    
    // fetchUserFollowings
    @Published var userFollowingList: [FollowingValues] = []
    @Published var userFollowingHasNextPage: Bool = false
    @Published var userFollowingCount: Int = 0
    
    private let followProvider = APIManager.shared.createProvider(for: FollowRouter.self)
    
    // MARK: - Functions
    func getDisplayList(for type: FollowType) -> [FollowDisplayModel] {
        switch type {
        case .follower:
            return followerList.map {
                FollowDisplayModel(
                    id: $0.followerId,
                    nickname: $0.nickname,
                    username: $0.username,
                    profileImgUrl: $0.profileImgDTO?.imageUrl,
                    isCore: $0.isCircle
                )
            }
        case .userFollower:
            return userFollowerList.map {
                FollowDisplayModel(
                    id: $0.followerId,
                    nickname: $0.nickname,
                    username: $0.username,
                    profileImgUrl: $0.profileImgDTO?.imageUrl,
                    isCore: false
                )
            }
        case .following:
            return followingList.map {
                FollowDisplayModel(
                    id: $0.followingId,
                    nickname: $0.nickname,
                    username: $0.username,
                    profileImgUrl: $0.profileImgDTO?.imageUrl,
                    isCore: false
                )
            }
        case .userFollowing:
            return userFollowingList.map {
                FollowDisplayModel(
                    id: $0.followingId,
                    nickname: $0.nickname,
                    username: $0.username,
                    profileImgUrl: $0.profileImgDTO?.imageUrl,
                    isCore: false
                )
            }
        }
    }
    
    func hasNextPage(for type: FollowType) -> Bool {
        switch type {
        case .follower:
            return followerHasNextPage
        case .following:
            return followingHasNextPage
        case .userFollower:
            return userFollowerHasNextPage
        case .userFollowing:
            return userFollowingHasNextPage
        }
    }
    
    func fetchMore(for type: FollowType, cursorId: Int) {
        switch type {
        case .follower:
            fetchFollowers(cursorId: cursorId)
        case .following:
            fetchFollowings(cursorId: cursorId)
        case .userFollower:
            fetchUserFollowers(targetUsername: currentTargetUsername, cursorId: cursorId)
        case .userFollowing:
            fetchUserFollowings(targetUsername: currentTargetUsername, cursorId: cursorId)
        }
    }
    
    func getCount(for type: FollowType) -> Int {
        switch type {
        case .follower:
            return followerCount
        case .following:
            return followingCount
        case .userFollower:
            return userFollowerCount
        case .userFollowing:
            return userFollowingCount
        }
    }
    
    // MARK: - Functions - API
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
    
    func fetchFollowings(
        cursorId: Int? = nil,
        size: Int? = 10
    ) {
        followProvider.request(.getFollowings(cursorId: cursorId, size: size)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(FollowingsResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.followingList = result.followingCursor.values
                        } else {
                            // 다음 페이지 -> append
                            self.followingList.append(contentsOf: result.followingCursor.values)
                        }
                        self.followingCount = result.totalCount
                        self.followingHasNextPage = result.followingCursor.hasNext
                    }
                } catch {
                    print("GetFollowings 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("GetFollowings API 오류: \(error)")
            }
        }
    }
    
    func fetchUserFollowers(
        targetUsername: String,
        cursorId: Int? = nil,
        size: Int? = 10
    ) {
        followProvider.request(.getFollowersTarget(
            targetUsername: targetUsername,
            cursorId: cursorId,
            size: size
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(UserFollowersResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.userFollowerList = result.followerCursor.values
                        } else {
                            // 다음 페이지 -> append
                            self.userFollowerList.append(contentsOf: result.followerCursor.values)
                        }
                        self.userFollowerCount = result.totalCount
                        self.userFollowerHasNextPage = result.followerCursor.hasNext
                    }
                } catch {
                    print("GetUserFollowers 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("GetUserFollowers API 오류: \(error)")
            }
        }
    }
    
    func fetchUserFollowings(
        targetUsername: String,
        cursorId: Int? = nil,
        size: Int? = 10
    ) {
        followProvider.request(.getFollowingsTarget(
            targetUsername: targetUsername,
            cursorId: cursorId,
            size: size
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(FollowingsResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.userFollowingList = result.followingCursor.values
                        } else {
                            // 다음 페이지 -> append
                            self.userFollowingList.append(contentsOf: result.followingCursor.values)
                        }
                        self.userFollowingCount = result.totalCount
                        self.userFollowingHasNextPage = result.followingCursor.hasNext
                    }
                } catch {
                    print("GetUserFollowings 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("GetUserFollowings API 오류: \(error)")
            }
        }
    }
}
