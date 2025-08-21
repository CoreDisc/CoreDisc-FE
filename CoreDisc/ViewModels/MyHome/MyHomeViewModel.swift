//
//  MyHomeViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/27/25.
//

import SwiftUI
import Moya
import PhotosUI

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
    @Published var idDuplicated: Bool = false
    @Published var idCheckSuccess: Bool = false
    
    // fetchNameCheck
    @Published var nameDuplicated: Bool = false
    @Published var nameCheckSuccess: Bool = false
    
    // fetchProfile
    @Published var logoutSuccess : Bool = false
    @Published var changeSuccess : Bool = false
    
    // 중복 확인 여부
    @Published var originalUsername: String = ""
    private var originalNickname: String = ""
    @Published var nextErrorUsername : Bool = false
    @Published var nextErrorNickname : Bool = false
    
    private let memberProvider = APIManager.shared.createProvider(for: MemberRouter.self)
    private let authProvider = APIManager.shared.createProvider(for: AuthRouter.self)
    
    //fetchProfileImage
    @Published var imageUrl: String = ""
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var profileUIImage: UIImage?
    @Published var imageChangeSuccess : Bool = false
    
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
                    
                    self.originalUsername = result.username
                    self.originalNickname = result.nickname
                } catch {
                    print("GetMyHome 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("마이홈 정보를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetMyHome 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("마이홈 정보를 불러오지 못했습니다.")
                }
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
                    DispatchQueue.main.async {
                        ToastManager.shared.show("마이홈 게시글을 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetMyPosts API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("마이홈 게시글을 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func fetchIdCheck(username: String) {
        authProvider.request(.getCheckUsername(username: username)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(EditCheckUsernameResponse.self, from: response.data)
                    self.idDuplicated = decodedData.result.duplicated
                    if !self.idDuplicated {
                        self.idCheckSuccess = true
                        self.nextErrorUsername = false
                        
                    }
                    
                } catch {
                    print("GetCheckUsername 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("아이디 중복 확인을 하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetCheckUsername API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("아이디 중복 확인을 하지 못했습니다.")
                }
            }
        }
    }
    
    func fetchNameCheck() {
        authProvider.request(.getCheckNickname(nickname: nickname)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(EditCheckNameResponse.self, from: response.data)
                    self.nameDuplicated = decodedResponse.result.duplicated
                    if !self.nameDuplicated {
                        self.nameCheckSuccess = true
                        self.nextErrorNickname = false
                        
                    }
                } catch {
                    print("디코딩 실패 : \(error)")
                }
            case .failure(let error):
                print("네트워크 오류 : \(error)")
            }
        }
    }
    
    func fetchProfile() {
        guard let FCMToken = KeychainManager.standard.loadString(for: "FCMToken") else {
            print("FCMToken 없음")
            return
        }
        memberProvider.request(.patchProfile(
            profilePatchData: ProfilePatchData(
                newNickname: nickname,
                newUsername: username,
            ),deviceToken: FCMToken
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(ProfileResponse.self, from: response.data)
                    print(decodedResponse.code)
                    if decodedResponse.code == "MEMBER2001" {
                        KeychainManager.standard.deleteSession(for: "appNameUser")
                        DispatchQueue.main.async {
                            self.logoutSuccess = true
                        }
                    } else if decodedResponse.code == "MEMBER2002" {
                        DispatchQueue.main.async {
                            self.changeSuccess = true
                        }
                    }
                    
                } catch {
                    print("디코딩 실패 : \(error)")
                }
            case .failure(let error):
                print("네트워크 오류 : \(error)")
            }
        }
    }
    
    func validateAndSubmit() {
        let usernameChanged = username != originalUsername
        let nicknameChanged = nickname != originalNickname
        
        var hasError = false
        
        if usernameChanged && !idCheckSuccess {
            nextErrorUsername = true
            hasError = true
        }
        
        if nicknameChanged && !nameCheckSuccess {
            nextErrorNickname = true
            hasError = true
        }
        
        if !hasError {
            fetchProfile()
        }
    }
    
    func fetchProfileImage(imageData: Data) {
        self.imageChangeSuccess = false
        
        memberProvider.request(.patchProfileImage(image: imageData)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(ImageResponse.self, from: response.data)
                    if let newUrl = decoded.result?.imageUrl {
                        DispatchQueue.main.async {
                            self.profileImageURL = newUrl
                            self.profileUIImage = nil
                            self.imageChangeSuccess = true
                        }
                    }
                    print("이미지 성공 : \(decoded)")
                } catch {
                    print("디코딩 실패: \(error)")
                }
            case .failure(let error):
                print("네트워크 오류: \(error)")
            }
        }
    }
    
    func fetchDefaultImage() {
        memberProvider.request(.patchDefaultImage) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(ImageResponse.self, from: response.data)
                    print("기본 이미지 성공 : \(decoded)")
                    self.fetchMyHome()
                } catch {
                    print("디코딩 실패: \(error)")
                }
            case .failure(let error):
                print("네트워크 오류: \(error)")
            }
        }
    }
}
