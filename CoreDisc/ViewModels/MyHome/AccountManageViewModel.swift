//
//  AccountManageViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 8/7/25.
//


import Foundation
import Moya

class AccountManageViewModel: ObservableObject {
    @Published var id: String = ""
    @Published var email: String = ""
    @Published var pwd: String = ""
    @Published var rePwd: String = ""
    @Published var newPwd: String = ""
    @Published var pwdError: Bool = false
    @Published var newPwdError: Bool = false
    @Published var rePwdError: Bool = false
    
    @Published var changeSuccess: Bool = false
    @Published var resignSuccess: Bool = false
    
    private let memberProvider = APIManager.shared.createProvider(for: MemberRouter.self)
    
    func changePw() {
        memberProvider.request(.patchMyhomePassword(
            myhomePasswordPatchData: MyhomePasswordPatchData(
                password: pwd,
                newPassword: newPwd,
                passwordCheck: rePwd
            )
        )){ result in
            switch result{
            case .success(let response):
                if let decodedResponse = try? JSONDecoder().decode(ChangeMyPwResponse.self, from: response.data) {
                    print("성공: \(decodedResponse.message)")
                }
                DispatchQueue.main.async {
                    self.changeSuccess = true
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let decodedResponse = try JSONDecoder().decode(ChangeMyPwResponse.self, from: response.data)
                        print("실패 : \(decodedResponse.message)")
                        switch decodedResponse.code {
                        case "AUTH4015":
                            self.pwdError = true
                        case "AUTH4016":
                            self.rePwdError = true
                        default:
                            break
                        }
                    } catch {
                        print("디코딩 실패 : \(error.localizedDescription)")
                    }
                } else {
                    print("네트워크 오류: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func resign() {
        memberProvider.request(.patchResign){ result in
            switch result{
            case .success(let response):
                if let decodedResponse = try? JSONDecoder().decode(resignResponse.self, from: response.data) {
                    print("탈퇴 성공: \(decodedResponse.message)")
                }
                DispatchQueue.main.async {
                    self.resignSuccess = true
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let decodedResponse = try JSONDecoder().decode(resignResponse.self, from: response.data)
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
}
