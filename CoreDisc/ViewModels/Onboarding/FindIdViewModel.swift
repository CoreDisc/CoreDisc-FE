//
//  FindIdViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 8/2/25.
//

import Foundation
import Moya

class FindIdViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var findedId: Bool = false
    @Published var isError: Bool = false
    @Published var id: String = ""
    
    private let authProvider = APIManager.shared.createProvider(for: AuthRouter.self)
    
    func findId() {
        authProvider.request(.postUsername(
            usernameData: UsernameData(
                name: name,
                email: email)
        )){ result in
            switch result {
            case .success(let response):
                if let decodedResponse = try? JSONDecoder().decode(FindIdResponse.self, from: response.data) {
                    print("성공: \(decodedResponse.message)")
                    guard let userId = decodedResponse.result?.username else { return }
                    DispatchQueue.main.async {
                        self.id = userId
                        self.findedId = true
                        self.isError = false
                    }
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let decodedResponse = try JSONDecoder().decode(FindIdResponse.self, from: response.data)
                        print("실패 : \(decodedResponse.message)")
                    } catch {
                        print("디코딩 실패 : \(error.localizedDescription)")
                    }
                    self.isError = true
                } else {
                    print("네트워크 오류: \(error.localizedDescription)")
                    self.isError = true
                }
            }
        }
    }
}
