//
//  SignupViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 8/1/25.
//

import Foundation
import Moya

class SignupViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordCheck: String = ""
    @Published var agreedTermsIds: String = ""
    @Published var code: String = ""
    
    @Published var emailErrorMessage: String = ""
    @Published var EmailVerified: Bool = false
    @Published var CodeVerified: Bool = false
    @Published var codeErrorMessage: String = ""
    @Published var isSignedUp = false
    
    private let authProvider = APIManager.shared.createProvider(for: AuthRouter.self)
    
    func sendCode() {
        authProvider.request(.postSendCode(email: email)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(SendCodeResponse.self, from: response.data)
                    
                    if decodedResponse.isSuccess {
                        print("성공: \(decodedResponse.message)")
                        self.EmailVerified = true
                        self.emailErrorMessage = ""
                    } else {
                        print("실패: \(decodedResponse.message)")
                        self.EmailVerified = false
                        switch decodedResponse.result {
                        case .error(let validationError):
                            self.emailErrorMessage = validationError.email
                        case .success(_), .none:
                            self.emailErrorMessage = decodedResponse.message
                        }
                    }
                } catch {
                    print("디코딩 오류: \(error.localizedDescription)")
                    self.EmailVerified = false
                    self.emailErrorMessage = "오류가 발생했습니다."
                }
                
            case .failure(let error):
                if let response = error.response {
                    do {
                        let decodedResponse = try JSONDecoder().decode(SendCodeResponse.self, from: response.data)
                        let errorMsg: String
                        switch decodedResponse.result {
                        case .error(let validationError):
                            errorMsg = validationError.email
                        case .success(_), .none:
                            errorMsg = decodedResponse.message
                        }
                        print("실패 : \(errorMsg)")
                        self.emailErrorMessage = errorMsg
                    } catch {
                        print("디코딩 실패 : \(error.localizedDescription)")
                        self.emailErrorMessage = "오류가 발생했습니다."
                    }
                    self.EmailVerified = false
                } else {
                    print("네트워크 오류: \(error.localizedDescription)")
                    self.EmailVerified = false
                    self.emailErrorMessage = "네트워크 오류가 발생했습니다."
                }
            }
        }
    }
    
    
    func verifyCode() {
        authProvider.request(.postVerifyCode(
            verifyCodeData: VerifySignupCodeData(
                email: email,
                code: code,
                emailRequestType: EmailRequestType.signup
            )
        )){ result in
            switch result{
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(VerifyCodeResponse.self, from: response.data)
                    
                    if decodedResponse.isSuccess {
                        print("성공 : \(String(describing: decodedResponse.result))")
                        self.CodeVerified = true
                        self.codeErrorMessage = "인증되었습니다."
                    } else {
                        print("실패 : \(decodedResponse.message)")
                        self.CodeVerified = true
                        self.codeErrorMessage = decodedResponse.message
                    }
                } catch {
                    print("디코딩 오류 : \(error.localizedDescription)")
                    self.CodeVerified = false
                    self.codeErrorMessage = "오류가 발생했습니다."
                }
            case .failure(let error):
                print("API 오류 : \(error.localizedDescription)")
                self.CodeVerified = false
                self.codeErrorMessage = "네트워크 오류가 발생했습니다."
            }
        }
    }
    
    func signup() {
        authProvider.request(.postSignup(
            signupData: SignupData(
                email: email,
                name: name,
                username: username,
                password: password,
                passwordCheck: passwordCheck,
                agreedTermsIds: [1,2,3]
            )
        )){ result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(SignupResponse.self, from: response.data)
                    
                    if decodedResponse.isSuccess {
                        print("성공 : \(String(describing: decodedResponse.result))")
                        DispatchQueue.main.async {
                            self.isSignedUp = true
                        }
                    } else{
                        print("실패 : \(decodedResponse.message)")
                    }
                } catch {
                    
                }
            case .failure(let error):
                print("API 오류 : \(error.localizedDescription)")
                self.CodeVerified = false
                self.codeErrorMessage = "네트워크 오류가 발생했습니다."
            }
        }
    }
}
