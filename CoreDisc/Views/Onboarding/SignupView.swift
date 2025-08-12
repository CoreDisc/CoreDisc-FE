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
    @FocusState private var isFocused: Bool

    @State private var pwdShown = false
    @State private var rePwdShown = false
    @State private var TermsModal: Int? = 0
    
    var body: some View {
        NavigationStack{
            ZStack {
                Image(.imgOnboardingBackground)
                    .resizable()
                    .ignoresSafeArea()
                    .onTapGesture { // 키보드 내리기 용도
                        isFocused = false
                    }
                ScrollView{
                    LazyVStack{
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
                if let id = TermsModal,
                   let term = viewModel.termsList.first(where: { $0.termsId == id }) {
                    TermsModalView(
                        essential: term.isRequired,
                        title: term.title,
                        action: { TermsModal = nil },
                        content: term.content
                    )
                }
            }
            .navigationBarBackButtonHidden()
        }
        .onAppear {
            viewModel.getTerms()
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
            
            Text("이메일")
                .textStyle(.Q_Main)
                .foregroundStyle(.white)
                .padding(.leading, 10)
            ZStack{
                InputView{
                    TextField("이메일을 입력해주세요.", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .focused($isFocused)
                        .onChange(of: viewModel.email) { oldValue, newValue in
                            if viewModel.emailSuccess {
                                viewModel.emailSuccess = false
                                viewModel.emailBoxColor = false
                            }
                        }
                }
                HStack{
                    Spacer()
                    Button(action: {
                        viewModel.CkeckEmail()
                    }, label: {
                        ZStack{
                            Capsule()
                                .frame(width: 63, height: 25)
                                .foregroundStyle((viewModel.email.isEmpty || viewModel.emailSuccess) ? .gray400 : .highlight)
                            Text("중복확인")
                                .textStyle(.Q_pick)
                                .foregroundStyle(.black000)
                        }
                        .padding(.horizontal)
                    })
                }
            }
            
            ButtonView(action:{viewModel.sendCode()}, label: {
                Text("인증 번호 전송")
            }, boxColor: (viewModel.email.isEmpty || !viewModel.emailBoxColor || viewModel.EmailVerified) ? .gray400 : .key)
            .disabled(viewModel.email.isEmpty || !viewModel.emailBoxColor || viewModel.EmailVerified)
            
            if viewModel.emailDuplicate {
                Text("이미 사용 중인 이메일입니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 20)
            } else if viewModel.EmailVerified {
                Text("인증번호가 전송되었습니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 8)
            } else if viewModel.emailSuccess {
                Text("사용 가능한 이메일입니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 8)
            } else {
                Spacer().frame(height: 28)
            }
     
            InputView{
                TextField("인증번호를 입력해주세요.", text: $viewModel.code)
                    .focused($isFocused)
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
                Spacer().frame(height: 20)
            } else {
                Spacer().frame(height: 40)
            }
            
            Text("아이디")
                .textStyle(.Q_Main)
                .foregroundStyle(.white)
                .padding(.leading, 10)
            
            ZStack{
                InputView{
                    TextField("아이디를 입력해주세요.", text: $viewModel.username)
                        .textInputAutocapitalization(.never)
                        .focused($isFocused)
                        .onChange(of: viewModel.username) { oldValue, newValue in
                            if viewModel.idSuccess {
                                viewModel.idSuccess = false
                            }
                        }
                }
                HStack{
                    Spacer()
                    Button(action: {
                        viewModel.CkeckUsername()
                    }, label: {
                        ZStack{
                            Capsule()
                                .frame(width: 63, height: 25)
                                .foregroundStyle((viewModel.username.isEmpty || viewModel.idSuccess) ? .gray400 : .highlight)
                            Text("중복확인")
                                .textStyle(.Q_pick)
                                .foregroundStyle(.black000)
                        }
                        .padding(.horizontal)
                    })
                }
            }
            
            if viewModel.idError {
                Text("16자 이내 영문,숫자,특수문자(_,.)만 사용 가능합니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("16자 이내 영문,숫자,특수문자(_,.)만 사용 가능합니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
            }
            
            if viewModel.idDuplicate {
                Text("동일한 아이디가 존재합니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 20)
            } else if viewModel.idSuccess {
                Text("사용 가능한 아이디입니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 20)
            }else {
                Spacer().frame(height: 40)
            }
            
            Text("비밀번호")
                .textStyle(.Q_Main)
                .foregroundStyle(.white)
                .padding(.leading, 10)
            
            InputView{
                if pwdShown{
                    HStack{
                        TextField("비밀번호를 입력해주세요.", text: $viewModel.password)
                            .focused($isFocused)
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
                            .focused($isFocused)
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
                        TextField("비밀번호를 한 번 더 입력해주세요.", text: $viewModel.passwordCheck)
                            .focused($isFocused)
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
                            .focused($isFocused)
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
                Spacer().frame(height: 20)
            } else {
                Spacer().frame(height: 40)
            }
            
            
            Text("이름")
                .textStyle(.Q_Main)
                .foregroundStyle(.white)
                .padding(.leading, 10)
            
            ZStack{
                InputView{
                    TextField("이름을 입력해주세요.", text: $viewModel.name)
                        .textInputAutocapitalization(.never)
                        .focused($isFocused)
                        .onChange(of: viewModel.name) { oldValue, newValue in
                            if viewModel.nameSuccess {
                                viewModel.nameSuccess = false
                            }
                        }
                }
                HStack{
                    Spacer()
                    Button(action: {
                        viewModel.CkeckName()
                    }, label: {
                        ZStack{
                            Capsule()
                                .frame(width: 63, height: 25)
                                .foregroundStyle((viewModel.name.isEmpty || viewModel.nameSuccess) ? .gray400 : .highlight)
                            Text("중복확인")
                                .textStyle(.Q_pick)
                                .foregroundStyle(.black000)
                        }
                        .padding(.horizontal)
                    })
                }
            }
            
            if viewModel.nicknameError {
                Text("16자 이내 영문,한글만 사용 가능합니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("16자 이내 영문,한글만 사용 가능합니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
            }
            if viewModel.nameDuplicate {
                Text("동일한 이름이 존재합니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 20)
            } else if viewModel.nameSuccess {
                Text("사용 가능한 이름입니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.gray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 20)
            } else {
                Spacer().frame(height: 40)
            }
            
            Divider()
                .frame(maxWidth: .infinity)
                .background(Color.white)
            
            Spacer().frame(height: 12)
            
            VStack{
                HStack{
                    Button(action: {
                        let newValue = !(viewModel.terms1 && viewModel.terms2 && viewModel.terms3 && viewModel.terms4)
                        viewModel.terms1 = newValue
                        viewModel.terms2 = newValue
                        viewModel.terms3 = newValue
                        viewModel.terms4 = newValue
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color.white, lineWidth: 1)
                                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                                .frame(width: 24, height: 24)
                            
                            if viewModel.terms1 && viewModel.terms2 && viewModel.terms3 && viewModel.terms4 {
                                Image(.iconChecking)
                            }
                        }
                    })
                    Text("전체 동의")
                        .textStyle(.Button_s)
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                TermsView(
                    essential: true,
                    text: "서비스 이용약관",
                    isChecked: viewModel.terms1,
                    toggle: { viewModel.terms1.toggle() },
                    action: {TermsModal = 1}
                )
                TermsView(
                    essential: true,
                    text: "개인정보 수집 및 이용 동의",
                    isChecked: viewModel.terms2,
                    toggle: { viewModel.terms2.toggle() },
                    action: {TermsModal = 2}
                )
                TermsView(
                    essential: true,
                    text: "만 14세 이상 여부 확인",
                    isChecked: viewModel.terms3,
                    toggle: { viewModel.terms3.toggle() },
                    action: {TermsModal = 3}
                )
                TermsView(
                    essential: false,
                    text: "마케팅 활용 및 광고 수신 동의",
                    isChecked: viewModel.terms4,
                    toggle: { viewModel.terms4.toggle() },
                    action: {TermsModal = 4}
                )
            }
            
            Spacer().frame(height: 12)
            
            Divider()
                .frame(maxWidth: .infinity)
                .background(Color.white)
            
            Spacer().frame(height: 22)
            ButtonView(action:{
                viewModel.codeErrorMessage = ""
                viewModel.pwdError = false
                viewModel.rePwdError = false
                viewModel.idError = false
                viewModel.nicknameError = false
                viewModel.signup()
            }, label: {
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
