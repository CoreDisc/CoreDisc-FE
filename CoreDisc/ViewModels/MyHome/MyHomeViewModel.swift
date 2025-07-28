//
//  MyHomeViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/27/25.
//

import Foundation
import Moya

@Observable
class MyHomeViewModel {
    // MARK: - Properties
    var username: String = ""
    var nickname: String = ""
    var followerCount: String = "0"
    var followingCount: String = "0"
    var postCount: String = "0"
    var profileImageURL: String = ""
    
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
}
