//
//  SignupViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 8/1/25.
//

import Foundation
import Moya

// 중복확인 추가 필요 + 약관 동의 추가 + 에러메세지 다양한 실패 테스트 필요
class SignupViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordCheck: String = ""
    @Published var code: String = ""
    
    @Published var emailErrorMessage: String = ""
    @Published var EmailVerified: Bool = false
    @Published var CodeVerified: Bool = false
    @Published var codeErrorMessage: String = ""
    @Published var isSignedUp: Bool = false
    @Published var pwdError: Bool = false
    @Published var rePwdError: Bool = false
    @Published var idError: Bool = false
    @Published var idDuplicate: Bool = false
    @Published var nicknameError: Bool = false
    @Published var nameDuplicate: Bool = false
    @Published var signupError: Bool = false
    @Published var terms1: Bool = false { didSet { updateAgreedTermsIds() } }
    @Published var terms2: Bool = false { didSet { updateAgreedTermsIds() } }
    @Published var terms3: Bool = false { didSet { updateAgreedTermsIds() } }
    @Published var terms4: Bool = false { didSet { updateAgreedTermsIds() } }
    
    @Published private(set) var agreedTermsIds: [Int] = []
    
    private func updateAgreedTermsIds() {
        var ids: [Int] = []
        if terms1 { ids.append(1) }
        if terms2 { ids.append(2) }
        if terms3 { ids.append(3) }
        if terms4 { ids.append(4) }
        agreedTermsIds = ids
    }
    
    private let authProvider = APIManager.shared.createProvider(for: AuthRouter.self)
    
    func sendCode() {
        authProvider.request(.postSendCode(email: email)) { result in
            switch result {
            case .success(let response):
                if let decodedResponse = try? JSONDecoder().decode(SendCodeResponse.self, from: response.data) {
                    print("성공: \(decodedResponse.message)")
                    self.EmailVerified = true
                    self.emailErrorMessage = ""
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let decodedResponse = try JSONDecoder().decode(SendCodeResponse.self, from: response.data)
                        let sendCodeErrorMsg: String
                        switch decodedResponse.result {
                        case .error(let validationError):
                            sendCodeErrorMsg = validationError.email
                        case .success(_), .none:
                            sendCodeErrorMsg = decodedResponse.message
                        }
                        print("실패 : \(sendCodeErrorMsg)")
                        self.emailErrorMessage = sendCodeErrorMsg
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
                if let decodedResponse = try? JSONDecoder().decode(VerifyCodeResponse.self, from: response.data) {
                    print("성공: \(decodedResponse.message)")
                    self.CodeVerified = true
                    self.codeErrorMessage = "인증되었습니다."
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let decodedResponse = try JSONDecoder().decode(SendCodeResponse.self, from: response.data)
                        let verifyCodeErrorMsg: String
                        switch decodedResponse.result {
                        case .error(let validationError):
                            verifyCodeErrorMsg = validationError.email
                        case .success(_), .none:
                            verifyCodeErrorMsg = decodedResponse.message
                        }
                        print("실패 : \(verifyCodeErrorMsg)")
                        self.codeErrorMessage = verifyCodeErrorMsg
                        
                        switch decodedResponse.code {
                        case "AUTH4002":
                            self.EmailVerified = false
                        case "AUTH4003":
                            break
                        default:
                            break
                        }
                        
                    } catch {
                        print("디코딩 실패 : \(error.localizedDescription)")
                        self.codeErrorMessage = "오류가 발생했습니다."
                    }
                    self.CodeVerified = false
                } else {
                    print("네트워크 오류: \(error.localizedDescription)")
                    self.CodeVerified = false
                    self.codeErrorMessage = "네트워크 오류가 발생했습니다."
                }
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
                agreedTermsIds: agreedTermsIds
            )
        )){ result in
            switch result {
            case .success(let response):
                if let decodedResponse = try? JSONDecoder().decode(SignupResponse.self, from: response.data) {
                    print("성공: \(decodedResponse.message)")
                    self.isSignedUp = true
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let decodedResponse = try JSONDecoder().decode(SendCodeResponse.self, from: response.data)
                        let signupErrorMsg: String
                        switch decodedResponse.result {
                        case .error(let validationError):
                            signupErrorMsg = validationError.email
                        case .success(_), .none:
                            signupErrorMsg = decodedResponse.message
                        }
                        print("실패 : \(signupErrorMsg)")
                        
                        switch decodedResponse.code {
                        case "COMMON400":
                            self.pwdError = true
                        case "AUTH4001":
                            self.rePwdError = true
                        case "AUTH4005":
                            self.nicknameError = true
                        case "AUTH4004":
                            self.idError = true
                        default:
                            break
                        }
                    } catch {
                        print("디코딩 실패 : \(error.localizedDescription)")
                        self.signupError = true
                    }
                } else {
                    print("네트워크 오류: \(error.localizedDescription)")
                }
            }
        }
    }
}
