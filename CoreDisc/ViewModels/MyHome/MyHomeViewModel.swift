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
    @Published var username: String = ""
    @Published var nickname: String = ""
    @Published var followerCount: String = "0"
    @Published var followingCount: String = "0"
    @Published var postCount: String = "0"
    @Published var profileImageURL: String = ""
    
    // fetchMyPosts
    @Published var postList: [MyHomePostValue] = []
    @Published var hasNextPage: Bool = false
    
    // fetchIdCheck
    @Published var duplicated: Bool = false
    
    private let memberProvider = APIManager.shared.createProvider(for: MemberRouter.self)
    private let authProvider = APIManager.shared.createProvider(for: AuthRouter.self)
    
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
                    print("GetMyPosts 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("GetMyPosts API 오류: \(error)")
            }
        }
    }
    
    func fetchIdCheck(username: String) {
        authProvider.request(.getCheckUsername(username: username)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(EditCheckUsernameResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    self.duplicated = result.duplicated
                } catch {
                    print("GetCheckUsername 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("GetCheckUsername API 오류: \(error)")
            }
        }
    }
}
