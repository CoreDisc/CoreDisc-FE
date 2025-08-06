//
//  FindPwViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 8/7/25.
//

import Foundation
import Moya

class FindPwViewModel: ObservableObject {
    @Published var state: String = "input"
    @Published var username: String = ""
    @Published var email: String = ""
    
    @Published var code: String = ""
    @Published var pwd: String = ""
    @Published var rePwd: String = ""
    @Published var pwdError: Bool = false
    @Published var rePwdError: Bool = false
    @Published var codeErrorMessage: String = ""
    @Published var changeSuccess: Bool = false
    
    private let authProvider = APIManager.shared.createProvider(for: AuthRouter.self)
    private let memberProvider = APIManager.shared.createProvider(for: MemberRouter.self)
    
    func sendCode() {
        authProvider.request(.postPasswordVerifyUser(
            verifyUserData: VerifyUserData(
                username: username,
                email: email)
        )){ result in
            switch result {
            case .success(let response):
                if let decodedResponse = try? JSONDecoder().decode(FindPwResponse.self, from: response.data) {
                    print("성공: \(decodedResponse.message)")
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let decodedResponse = try JSONDecoder().decode(FindPwResponse.self, from: response.data)
                        print("실패 : \(decodedResponse.message)")
                    } catch {
                        print("디코딩 실패 : \(error.localizedDescription)")
                    }
                } else {
                    print("네트워크 오류: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func verifyCode() {
        authProvider.request(.postPasswordVerifyCode(
            verifyCodeData: VerifyCodeData(
                username: username,
                code: code,
                emailRequestType: EmailRequestType.resetPassword
            )
        )){ result in
            switch result{
            case .success(let response):
                if let decodedResponse = try? JSONDecoder().decode(VerifyPwCodeResponse.self, from: response.data) {
                    print("성공: \(decodedResponse.message)")
                    self.state = "changePw"
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let decodedResponse = try JSONDecoder().decode(VerifyPwCodeResponse.self, from: response.data)
                        print("실패 : \(decodedResponse.message)")
                        self.codeErrorMessage = "인증번호를 다시 확인해주세요."
                    } catch {
                        print("디코딩 실패 : \(error.localizedDescription)")
                        self.codeErrorMessage = "오류가 발생했습니다."
                    }
                } else {
                    print("네트워크 오류: \(error.localizedDescription)")
                    self.codeErrorMessage = "네트워크 오류가 발생했습니다."
                }
            }
        }
    }
    
    func changePw() {
        memberProvider.request(.patchPassword(
            passwordPatchData: PasswordPatchData(
                username: username,
                newPassword: pwd,
                passwordCheck: rePwd
            )
        )){ result in
            switch result{
            case .success(let response):
                if let decodedResponse = try? JSONDecoder().decode(ChangePwResponse.self, from: response.data) {
                    print("성공: \(decodedResponse.message)")
                }
                DispatchQueue.main.async {
                    self.changeSuccess = true
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let decodedResponse = try JSONDecoder().decode(ChangePwResponse.self, from: response.data)
                        print("실패 : \(decodedResponse.message)")
                        switch decodedResponse.code {
                        case "COMMON400":
                            self.pwdError = true
                        case "AUTH4001":
                            self.rePwdError = true
                        default:
                            break
                        }
                    } catch {
                        print("디코딩 실패 : \(error.localizedDescription)")
                        self.codeErrorMessage = "오류가 발생했습니다."
                    }
                } else {
                    print("네트워크 오류: \(error.localizedDescription)")
                    self.codeErrorMessage = "네트워크 오류가 발생했습니다."
                }
            }
        }
    }
}
