//
//  LoginViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 8/1/25.
//

import Foundation
import Moya

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLogin = false
    @Published var isError = false
    
    private let authProvider = APIManager.shared.createProvider(for: AuthRouter.self)
    
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
}
