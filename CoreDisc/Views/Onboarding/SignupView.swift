//
//  SignupView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/11/25.
//

import SwiftUI

struct SignupView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SignupViewModel()

    @State private var emailError = false
    @State private var numberSend = false
    @State private var numberError = false
    @State private var numberAuth = false
    @State private var pwdShown = false
    @State private var pwdError = false
    @State private var rePwdShown = false
    @State private var rePwdError = false
    @State private var idError = false
    @State private var nicknameError = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                Image(.imgOnboardingBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack{
                    HStack{
                        Button(action: {
                            dismiss()
                        }){
                            Image(.imgGoback)
                                .padding()
                        }
                        Spacer()
                    }
                    Image(.imgLogo)
                        .resizable()
                        .frame(width: 60, height: 36)
                    Spacer().frame(height: 31)
                    MainGroup
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    private var MainGroup : some View{
        VStack(alignment: .leading){
            HStack{
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
                Text("회원 가입")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 36)
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 32)
            
            InputView{
                TextField("이메일을 입력해주세요.", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
            }
            
            ButtonView(action:{viewModel.sendCode()}, label: {
                Text("인증 번호 전송")
            }, boxColor: (viewModel.email.isEmpty || viewModel.EmailVerified) ? .gray400 : .key)
            .disabled(viewModel.email.isEmpty || viewModel.EmailVerified)
            
            if !viewModel.emailErrorMessage.isEmpty {
                Text(viewModel.emailErrorMessage)
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 19)
            } else if viewModel.EmailVerified {
                Text("인증번호가 전송되었습니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 19)
            } else {
                Spacer().frame(height: 34)
            }
     
            InputView{
                TextField("인증번호를 입력해주세요.", text: $viewModel.code)
            }
            
            ButtonView(action:{viewModel.verifyCode()}, label: {
                Text("인증하기")
            }, boxColor: (viewModel.code.isEmpty || viewModel.CodeVerified) ? .gray400 : .key)
            .disabled(viewModel.code.isEmpty || viewModel.CodeVerified)
            
            if viewModel.CodeVerified {
                Text("인증되었습니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 19)
            } else if !viewModel.codeErrorMessage.isEmpty {
                Text(viewModel.codeErrorMessage)
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 19)
            } else {
                Spacer().frame(height: 34)
            }
            
            
            InputView{
                if pwdShown{
                    HStack{
                        TextField("비밀번호를 입력해주세요.", text: $viewModel.password)
                        Spacer()
                        Button(action:{
                            pwdShown.toggle()
                        }, label: {
                            Image(.iconShown)
                                .padding(.horizontal)
                        })
                    }
                } else{
                    HStack{
                        SecureField("비밀번호를 입력해주세요.", text: $viewModel.password)
                        Spacer()
                        Button(action:{
                            pwdShown.toggle()
                        }, label: {
                            Image(.iconNotShown)
                                .padding(.horizontal)
                        })
                    }
                }
            }
            
            if pwdError {
                Text("영문/숫자/특수문자(공백제외), 10~16자로 입력해주세요.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("영문/숫자/특수문자(공백제외), 10~16자로 입력해주세요.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
            }
            
            InputView{
                if rePwdShown{
                    HStack{
                        TextField("비밀번호를 한 번 더 입력해주세요.", text: $viewModel.passwordCheck)
                        Spacer()
                        Button(action:{
                            rePwdShown.toggle()
                        }, label: {
                            Image(.iconShown)
                                .padding(.horizontal)
                        })
                    }
                } else{
                    HStack{
                        SecureField("비밀번호를 한 번 더 입력해주세요.", text: $viewModel.passwordCheck)
                        Spacer()
                        Button(action:{
                            rePwdShown.toggle()
                        }, label: {
                            Image(.iconNotShown)
                                .padding(.horizontal)
                        })
                    }
                }
            }
            
            if rePwdError {
                Text("비밀번호가 일치하지 않습니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 19)
            } else {
                Spacer().frame(height: 34)
            }
            
            InputView{
                TextField("아이디를 입력해주세요.", text: $viewModel.username)
            }
            
            if idError {
                Text("16자 이내 영문,숫자,특수문자(_,.)만 사용 가능합니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("16자 이내 영문,숫자,특수문자(_,.)만 사용 가능합니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
            }
            
            InputView{
                TextField("이름을 입력해주세요.", text: $viewModel.name)
            }
            
            if nicknameError {
                Text("16자 이내 영문,한글만 사용 가능합니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("16자 이내 영문,한글만 사용 가능합니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
            }
            
            Spacer().frame(height: 22)
            
            ButtonView(action:{viewModel.signup()}, label: {
                Text("가입하기")
            }, boxColor: (viewModel.email.isEmpty || viewModel.code.isEmpty || viewModel.password.isEmpty || viewModel.passwordCheck.isEmpty || viewModel.username.isEmpty || viewModel.name.isEmpty) ? .gray400 : .key)
            .disabled(viewModel.email.isEmpty || viewModel.code.isEmpty || viewModel.password.isEmpty || viewModel.passwordCheck.isEmpty || viewModel.username.isEmpty || viewModel.name.isEmpty)
            
            .navigationDestination(isPresented: $viewModel.isSignedUp) {
                LoginView()
            }
        }
        .padding(.horizontal, 41)
    }
}

#Preview {
    SignupView()
}
