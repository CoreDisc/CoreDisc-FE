//
//  SignupView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/11/25.
//

import SwiftUI

struct SignupView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var email: String = ""
    @State var auth: String = ""
    @State var pwd: String = ""
    @State var repwd: String = ""
    @State var id: String = ""
    @State var name: String = ""
    
    @State private var emailError = false
    @State private var numberSend = true
    @State private var numberError = true
    @State private var numberAuth = true
    @State private var pwdShown = false
    @State private var pwdError = true
    @State private var rePwdShown = false
    @State private var rePwdError = true
    @State private var idError = true
    @State private var nicknameError = true
    
    var body: some View {
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
                TextField("이메일을 입력해주세요.", text: $email)
            }
            
            ButtonView(action:{print("인증 번호 전송")}, label: {
                Text("인증 번호 전송")
            }, boxColor: (email.isEmpty || emailError) ? .gray400 : .key)
            .disabled(email.isEmpty)
            
            if emailError {
                Text("잘못된 이메일 형식입니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 19)
            } else if numberSend {
                Text("인증번호가 전송되었습니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 19)
            }
            else {
                Spacer().frame(height: 34)
            }
     
            InputView{
                TextField("인증번호를 입력해주세요.", text: $auth)
            }
            
            ButtonView(action:{print("인증하기")}, label: {
                Text("인증하기")
            }, boxColor: (auth.isEmpty || emailError) ? .gray400 : .key)
            .disabled(auth.isEmpty)
            
            if numberAuth{
                Text("인증되었습니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 19)
            } else if numberError {
                Text("인증번호를 다시 확인해주세요.")
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
                        TextField("비밀번호를 입력해주세요.", text: $pwd)
                        Spacer()
                        Button(action:{
                            pwdShown.toggle()
                        }, label: {
//                            Image(.iconShown)
//                                .padding(.horizontal)
                        })
                    }
                } else{
                    HStack{
                        SecureField("비밀번호를 입력해주세요.", text: $pwd)
                        Spacer()
                        Button(action:{
                            pwdShown.toggle()
                        }, label: {
//                            Image(.iconNotShown)
//                                .padding(.horizontal)
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
                        TextField("비밀번호를 한 번 더 입력해주세요.", text: $repwd)
                        Spacer()
                        Button(action:{
                            rePwdShown.toggle()
                        }, label: {
//                            Image(.iconShown)
//                                .padding(.horizontal)
                        })
                    }
                } else{
                    HStack{
                        SecureField("비밀번호를 한 번 더 입력해주세요.", text: $repwd)
                        Spacer()
                        Button(action:{
                            rePwdShown.toggle()
                        }, label: {
//                            Image(.iconNotShown)
//                                .padding(.horizontal)
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
                TextField("아이디를 입력해주세요.", text: $id)
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
                TextField("이름을 입력해주세요.", text: $name)
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
            
            ButtonView(action:{print("가입하기")}, label: {
                Text("가입하기")
            }, boxColor: (email.isEmpty || auth.isEmpty || pwd.isEmpty || repwd.isEmpty || id.isEmpty || name.isEmpty) ? .gray400 : .key)
            .disabled(email.isEmpty || auth.isEmpty || pwd.isEmpty || repwd.isEmpty || id.isEmpty || name.isEmpty)
            
        }
        .padding(.horizontal, 41)
    }
}

#Preview {
    SignupView()
}
