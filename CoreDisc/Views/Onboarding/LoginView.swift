//
//  LoginView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI
import Moya

struct LoginView: View {
    @Environment(NavigationRouter<OnboardingRoute>.self) private var router
    
    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Image(.imgOnboardingBackground)
                .resizable()
                .ignoresSafeArea()
                .onTapGesture { // 키보드 내리기 용도
                    isFocused = false
                }
            
            VStack{
                Image(.imgLogo)
                    .resizable()
                    .frame(width: 60, height: 36)
                Spacer().frame(height: 51)
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
        }
        .fullScreenCover(isPresented: $viewModel.isLogin) {
            TabBar()
        }
        .navigationBarBackButtonHidden()
    }
    
    private var MainGroup : some View{
        VStack{
            HStack{
                Divider()
                    .frame(width: 80, height: 1)
                    .background(Color.white)
                Text("로그인 또는 가입")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                Divider()
                    .frame(width: 80, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 24)
            
            InputView{
                TextField("아이디", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .focused($isFocused)
            }
            
            InputView{
                SecureField("비밀번호", text: $viewModel.password)
                    .focused($isFocused)
            }
            
            if viewModel.isError {
                Text("아이디 혹은 비밀번호가 일치하지 않습니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 16)
            } else {
                Spacer().frame(height: 36)
            }
            
            ButtonView(action:{viewModel.login()}, label: {
                Text("로그인")
            }, boxColor: (viewModel.username.isEmpty || viewModel.password.isEmpty) ? .gray400 : .key)
            .disabled(viewModel.username.isEmpty || viewModel.password.isEmpty)
            
            Spacer().frame(height: 37)
            
            HStack{
                Button(action: {
                    router.push(.signup)
                }) {
                    Text("회원가입")
                        .textStyle(.login_info)
                        .underline()
                        .foregroundStyle(.key)
                }
                
                Spacer().frame(width: 32)
                
                Button(action: {
                    router.push(.findId)
                }) {
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
                    .frame(width: 80, height: 1)
                    .background(Color.white)
                Text("간편 로그인")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                Divider()
                    .frame(width: 80, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 32)
            
            HStack(spacing: 43){
                Image(.imgNaver)
                
                Button(action: {
                    viewModel.kakaoLogin()
                }) {
                    Image(.imgKakao)
                }
                
                Image(.imgApple)
            }
        }
        .padding(.horizontal, 41)
    }
}

#Preview {
    LoginView()
}
