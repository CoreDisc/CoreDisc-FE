//
//  LoginViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 8/1/25.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Moya

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLogin = false
    @Published var isError = false
    
    private let authProvider = APIManager.shared.createProvider(for: AuthRouter.self)
    let provider = APIManager.shared.createProvider(for: NotificationRouter.self)
    
    func fetchFcmToken() {
        if let fcm = KeychainManager.standard.loadString(for: "FCMToken") {
            provider.request(.postDeviceToken(token: fcm)) { result in
                switch result {
                case .success(let response):
                    do {
                        _ = try JSONDecoder().decode(DeviceTokenResponse.self, from: response.data)
                        print("디바이스 토큰 전송 성공")
                    } catch {
                        print("PostDeviceToken 디코더 오류: \(error)")
                        DispatchQueue.main.async {
                            ToastManager.shared.show("FCM 토큰을 전송하지 못했습니다.")
                        }
                    }
                case .failure(let error):
                    print("PostDeviceToken API 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("FCM 토큰을 전송하지 못했습니다.")
                    }
                }
            }
        }
    }
    
    func login() {
        authProvider.request(.postLogin(loginData: LoginData(
            username: username,
            password: password
        ))) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: response.data)
                    
                    let userInfo = UserInfo(
                        accessToken: decodedResponse.result?.accessToken,
                        refreshToken: decodedResponse.result?.refreshToken
                    )
                    
                    let saved = KeychainManager.standard.saveSession(userInfo, for: "appNameUser")
                    
                    if saved {
                        print("로그인 성공 : \(String(describing: decodedResponse.result))")
                        DispatchQueue.main.async {
                            self.isLogin = true
                            self.isError = false
                        }
                        self.fetchFcmToken()
                    } else{
                        print("로그인 실패 : \(decodedResponse.message)")
                        self.isError = true
                    }
                } catch {
                    print("로그인 디코딩 오류 : \(error.localizedDescription)")
                    self.isError = true
                }
            case .failure(let error):
                print("로그인 API 오류 : \(error.localizedDescription)")
                self.isError = true
            }
        }
    }
    
    func kakaoLogin() {
        let provider = APIManager.shared.createProvider(for: AuthRouter.self)
        func kakaoLogin(accessToken: String) {
            provider.request(.postKakao(accessToken: accessToken)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(KakaoResponse.self, from: response.data)
                        
                        let userInfo = UserInfo(
                            accessToken: decodedData.result.accessToken,
                            refreshToken: decodedData.result.refreshToken
                        )
                        
                        // 토큰 KeyChain에 저장
                        let saved = KeychainManager.standard.saveSession(userInfo, for: "appNameUser")
                        if saved {
                            print("Token 저장 성공: \(String(describing: userInfo.accessToken))")
                            self.isLogin = true // 화면 전환
                        } else {
                            print("Token 저장 실패")
                        }
                    } catch {
                        print("KakaoResponse 디코더 오류: \(error)")
                    }
                case .failure(let error):
                    print("Kakao Login Error: \(error)")
                }
            }
        }
        
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    if let accessToken = oauthToken?.accessToken {
                        kakaoLogin(accessToken: accessToken)
                    }
                }
            }
        } else {
            // 카카오계정 로그인
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    if let accessToken = oauthToken?.accessToken {
                        kakaoLogin(accessToken: accessToken)
                    }
                }
            }
        }
    }
}
