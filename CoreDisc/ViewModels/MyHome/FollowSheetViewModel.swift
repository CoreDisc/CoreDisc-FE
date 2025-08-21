//
//  FollowersSheetViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/16/25.
//

import Foundation
import Moya

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
    
    // fetchCircleList
    @Published var coreList: [FollowerValues] = []
    @Published var coreHasNextPage: Bool = false
    @Published var coreCount: Int = 0
    
    private let followProvider = APIManager.shared.createProvider(for: FollowRouter.self)
    private let circleProvier = APIManager.shared.createProvider(for: CircleRouter.self)
    
    // MARK: - Functions
    func getDisplayList(for type: FollowType) -> [FollowDisplayModel] {
        switch type {
        case .follower:
            return followerList.map {
                FollowDisplayModel(
                    followId: $0.followId,
                    id: $0.followerId,
                    nickname: $0.nickname,
                    username: $0.username,
                    profileImgUrl: $0.profileImgDTO?.imageUrl,
                    isCore: $0.isCircle,
                    isMutual: $0.isMutual
                )
            }
        case .userFollower:
            return userFollowerList.map {
                FollowDisplayModel(
                    followId: $0.followId,
                    id: $0.followerId,
                    nickname: $0.nickname,
                    username: $0.username,
                    profileImgUrl: $0.profileImgDTO?.imageUrl,
                    isCore: false,
                    isMutual: nil
                )
            }
        case .following:
            return followingList.map {
                FollowDisplayModel(
                    followId: $0.followId,
                    id: $0.followingId,
                    nickname: $0.nickname,
                    username: $0.username,
                    profileImgUrl: $0.profileImgDTO?.imageUrl,
                    isCore: false,
                    isMutual: nil
                )
            }
        case .userFollowing:
            return userFollowingList.map {
                FollowDisplayModel(
                    followId: $0.followId,
                    id: $0.followingId,
                    nickname: $0.nickname,
                    username: $0.username,
                    profileImgUrl: $0.profileImgDTO?.imageUrl,
                    isCore: false,
                    isMutual: nil
                )
            }
        case .coreList:
            return coreList.map {
                FollowDisplayModel(
                    followId: $0.followId,
                    id: $0.followerId,
                    nickname: $0.nickname,
                    username: $0.username,
                    profileImgUrl: $0.profileImgDTO?.imageUrl,
                    isCore: $0.isCircle,
                    isMutual: true
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
        case .coreList:
            return coreHasNextPage
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
        case .coreList:
            fetchCircleList(cursorId: cursorId)
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
        case .coreList:
            return coreCount
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
                    DispatchQueue.main.async {
                        ToastManager.shared.show("팔로워 리스트를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetFollowers API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("팔로워 리스트를 불러오지 못했습니다.")
                }
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
                    DispatchQueue.main.async {
                        ToastManager.shared.show("팔로잉 리스트를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetFollowings API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("팔로잉 리스트를 불러오지 못했습니다.")
                }
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
                    DispatchQueue.main.async {
                        ToastManager.shared.show("타사용자 팔로워 리스트를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetUserFollowers API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("타사용자 팔로워 리스트를 불러오지 못했습니다.")
                }
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
                    DispatchQueue.main.async {
                        ToastManager.shared.show("타사용자 팔로잉 리스트를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetUserFollowings API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("타사용자 팔로잉 리스트를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func fetchCircle(
        targetId: Int,
        isCircle: Bool,
        completion: (() -> Void)? = nil
    ) {
        circleProvier.request(.patchCircle(targetId: targetId, isCircle: isCircle)) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try JSONDecoder().decode(CircleResponse.self, from: response.data)
                    completion?()
                } catch {
                    print("PatchCircle 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("코어리스트 설정을 변경하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PatchCircle API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("코어리스트 설정을 변경하지 못했습니다.")
                }
            }
        }
    }
    
    func fetchCircleList(
        cursorId: Int? = nil,
        size: Int? = 10
    ) {
        circleProvier.request(.getCircle(cursorId: cursorId, size: size)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(FollowersResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.coreList = result.followerCursor.values
                        } else {
                            // 다음 페이지 -> append
                            self.coreList.append(contentsOf: result.followerCursor.values)
                        }
                        self.coreCount = result.totalCount
                        self.coreHasNextPage = result.followerCursor.hasNext
                    }
                } catch {
                    print("GetCircle 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("코어리스트를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetCircle API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("코어리스트를 불러오지 못했습니다.")
                }
            }
        }
    }
}
