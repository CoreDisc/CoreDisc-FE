//
//  FindPwView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/11/25.
//

import SwiftUI

struct FindPwView: View {
    @Environment(NavigationRouter<OnboardingRoute>.self) private var router
    
    @StateObject private var viewModel = FindPwViewModel()
    @FocusState private var isFocused: Bool
    
    @State private var pwdShown = false
    @State private var rePwdShown = false
    
    var body: some View {
            ZStack {
                Image(.imgOnboardingBackground)
                    .resizable()
                    .ignoresSafeArea()
                    .onTapGesture { // 키보드 내리기 용도
                        isFocused = false
                    }
                VStack{
                    Spacer().frame(height: 96)
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
                    
                    if viewModel.state == "input" {
                        InputGroup
                    } else if viewModel.state == "auth" {
                        AuthGroup
                    } else {
                        ChangeGroup
                    }
                    Spacer()
                }
            }
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $viewModel.changeSuccess) {
            LoginView()
        }
    }
    private var InputGroup : some View{
        VStack{
            HStack{
                Divider()
                    .frame(width: 80, height: 1)
                    .background(Color.white)
                Text("비밀번호 변경하기")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 26)
                Divider()
                    .frame(width: 80, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 24)
            
            InputView{
                TextField("아이디", text: $viewModel.username)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never)
            }
            
            InputView{
                TextField("이메일", text: $viewModel.email)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never)
            }
            
            Spacer().frame(height: 36)
            
            ButtonView(action:{viewModel.state = "auth"; viewModel.sendCode()}, label: {
                Text("인증번호 발송하기")
            }, boxColor: (viewModel.username.isEmpty || viewModel.email.isEmpty) ? .gray400 : .key)
            .disabled(viewModel.username.isEmpty || viewModel.email.isEmpty)
            
            Spacer().frame(height: 12)
            
            Button(action: {
                router.reset()
            }) {
                ZStack{
                    Rectangle()
                        .frame(height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.gray400)
                    Text("로그인 화면으로 돌아가기")
                        .textStyle(.login_info)
                        .foregroundStyle(.black000)
                }
            }
        }.padding(.horizontal, 41)
    }
    
    private var AuthGroup : some View{
        VStack(alignment: .leading){
            HStack{
                Divider()
                    .frame(width: 80, height: 1)
                    .background(Color.white)
                Text("비밀번호 변경하기")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 26)
                Divider()
                    .frame(width: 80, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 24)

            InputView{
                TextField("인증번호 6자리", text: $viewModel.code)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never)
            }
            
            if viewModel.codeErrorMessage.isEmpty {
                Text("계정정보가 확인되면, 해당 이메일로 인증번호를 전송해드립니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.white)
            } else{
                Text(viewModel.codeErrorMessage)
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
            }
            Spacer().frame(height: 72)

            ButtonView(action:{ viewModel.verifyCode() }, label: {
                Text("인증하기")
            }, boxColor: (viewModel.code.isEmpty) ? .gray400 : .key)
            .disabled(viewModel.code.isEmpty)

            Spacer().frame(height: 12)
            
            Button(action: {
                router.reset()
            }) {
                ZStack{
                    Rectangle()
                        .frame(height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.gray400)
                    Text("로그인 화면으로 돌아가기")
                        .textStyle(.login_info)
                        .foregroundStyle(.black000)
                }
            }

        }.padding(.horizontal, 41)
    }
    private var ChangeGroup : some View{
        VStack(alignment: .leading){
            HStack{
                Divider()
                    .frame(width: 80, height: 1)
                    .background(Color.white)
                Text("비밀번호 변경하기")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 26)
                Divider()
                    .frame(width: 80, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 24)
            
            InputView{
                if pwdShown{
                    HStack{
                        TextField("비밀번호를 입력해주세요.", text: $viewModel.pwd)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
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
                        SecureField("비밀번호를 입력해주세요.", text: $viewModel.pwd)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
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
            
            if viewModel.pwdError {
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
                        TextField("비밀번호를 한 번 더 입력해주세요.", text: $viewModel.rePwd)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
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
                        SecureField("비밀번호를 한 번 더 입력해주세요.", text: $viewModel.rePwd)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
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
            
            if viewModel.rePwdError {
                Text("비밀번호가 일치하지 않습니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 19)
            } else {
                Spacer().frame(height: 34)
            }
            
            Spacer().frame(height: 36)
            
            ButtonView(action:{
                viewModel.pwdError = false
                viewModel.rePwdError = false
                viewModel.changePw()
            }, label: {
                Text("변경하기")
            }, boxColor: (viewModel.pwd.isEmpty || viewModel.rePwd.isEmpty) ? .gray400 : .key)
            .disabled(viewModel.pwd.isEmpty || viewModel.rePwd.isEmpty)
            
            Spacer().frame(height: 12)
            
            Button(action: {
                router.reset()
            }) {
                ZStack{
                    Rectangle()
                        .frame(height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.gray400)
                    Text("로그인 화면으로 돌아가기")
                        .textStyle(.login_info)
                        .foregroundStyle(.black000)
                }
            }
        }.padding(.horizontal, 41)
    }
}

#Preview {
    FindPwView()
}
