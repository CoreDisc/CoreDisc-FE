//
//  LoginView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Moya

struct LoginView: View {
    @State var id: String = ""
    @State var pwd: String = ""
    @State private var isLoginSuccess = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.imgOnboardingBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack{
                    Rectangle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.key)
                    Spacer().frame(height: 16)
                    Text("Shoot Your")
                        .textStyle(.Title_Text_Ko)
                        .foregroundStyle(.white)
                    Text("Core.")
                        .textStyle(.Title_Text_Ko)
                        .foregroundStyle(.white)
                    
                    Spacer().frame(height: 16)
                    MainGroup
                    Spacer().frame(height: 43)
                    SocialLoginGroup
                }
                .navigationDestination(isPresented: $isLoginSuccess) {
                    TabBar()
                }
            }
        }
    }
    
    private var MainGroup : some View{
        VStack{
            HStack{
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
                Text("로그인 또는 가입")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 24)
            
            ZStack{
                Capsule()
                    .frame(height: 40)
                    .foregroundStyle(.white)
                TextField("아이디", text: $id)
                    .textStyle(.login_info)
                    .padding(.leading, 31)
            }
            
            ZStack{
                Capsule()
                    .frame(height: 40)
                    .foregroundStyle(.white)
                SecureField("비밀번호", text: $pwd)
                    .textStyle(.login_info)
                    .padding(.leading, 31)
            }
            
            Spacer().frame(height: 36)
            
            Button(action:{}, label: {
                ZStack{
                    Rectangle()
                        .frame(height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.gray400)
                    Text("로그인")
                        .textStyle(.login_info)
                        .foregroundStyle(.black000)
                }
            })
            
            Spacer().frame(height: 37)
            
            HStack{
                NavigationLink(destination: SignupView()) {
                    Text("회원가입")
                        .textStyle(.login_info)
                        .underline()
                        .foregroundStyle(.highlight)
                }
                
                Spacer().frame(width: 32)
                
                NavigationLink(destination: FindIdView()) {
                    Text("아이디/비밀번호 찾기")
                        .textStyle(.login_info)
                        .underline()
                        .foregroundStyle(.white)
                }
            }
            
        }.padding(.horizontal, 41)
    }
    
    private var SocialLoginGroup : some View{
        VStack{
            HStack{
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
                Text("간편 로그인")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 32)
            
            HStack(spacing: 43){
                Image(.imgNaver)
                KakaoLoginButton(isLoginSuccess: $isLoginSuccess)
                Image(.imgGoogle)
            }
        }
        .padding(.horizontal, 41)
    }
}

// 카카오 로그인 버튼
struct KakaoLoginButton: View {
    @Binding var isLoginSuccess: Bool
    
    var body: some View {
        Button(action: {
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
                                isLoginSuccess = true // 화면 전환
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
        }) {
            Image(.imgKakao)
        }
    }
}

#Preview {
    LoginView()
}
