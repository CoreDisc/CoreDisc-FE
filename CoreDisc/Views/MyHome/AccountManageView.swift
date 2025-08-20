//
//  AccountManageView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/21/25.
//

import SwiftUI

struct AccountManageView: View {
    @Environment(NavigationRouter<MyhomeRoute>.self) private var router
    
    @StateObject private var viewModel = AccountManageViewModel()
    @FocusState private var isFocused: Bool
    
    @State private var pwdShown = false
    @State private var newPwdShown = false
    @State private var rePwdShown = false

    
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
                .onTapGesture { // 키보드 내리기 용도
                    isFocused = false
                }
            
            VStack{
                TopMenuGroup
                Spacer().frame(height: 13)
                MainGroup
                Spacer()
            }
            

        }
        .navigationBarBackButtonHidden()
    }
    
    private var TopMenuGroup: some View {
        ZStack(alignment: .top) {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.highlight)
                    .frame(width: 28, height: 55)
                    .offset(x: -14)
                Spacer()
            }
            
            ZStack {
                Text("비밀번호 변경")
                    .textStyle(.Button)
                    .foregroundStyle(.gray200)
                
                HStack {
                    Button(action: {
                        router.pop()
                    }) {
                        Image(.iconBack)
                    }
                    
                    Spacer()
                }
                .padding(.leading, 17)
                .padding(.trailing, 22)
            }
        }
    }
    
    private var MainGroup: some View {
        VStack(alignment: .leading){
            Text("비밀번호 변경")
                .textStyle(.A_Main)
                .foregroundStyle(.white)
            InputView{
                if pwdShown{
                    HStack{
                        TextField("현재 비밀번호를 입력해주세요.", text: $viewModel.pwd)
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
                        SecureField("현재 비밀번호를 입력해주세요.", text: $viewModel.pwd)
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
                Text("비밀번호가 틀렸습니다.")
                    .textStyle(.login_alert)
                    .foregroundStyle(.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Spacer().frame(height:21)
            }
            
            InputView{
                if newPwdShown{
                    HStack{
                        TextField("새로운 비밀번호를 입력해주세요.", text: $viewModel.newPwd)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
                        Spacer()
                        Button(action:{
                            newPwdShown.toggle()
                        }, label: {
                            Image(.iconShown)
                                .padding(.horizontal)
                        })
                    }
                } else{
                    HStack{
                        SecureField("새로운 비밀번호를 입력해주세요.", text: $viewModel.newPwd)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
                        Spacer()
                        Button(action:{
                            newPwdShown.toggle()
                        }, label: {
                            Image(.iconNotShown)
                                .padding(.horizontal)
                        })
                    }
                }
            }
            
            if viewModel.newPwdError {
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
                        TextField("새로운 비밀번호를 한 번 더 입력해주세요.", text: $viewModel.rePwd)
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
                        SecureField("새로운 비밀번호를 한 번 더 입력해주세요.", text: $viewModel.rePwd)
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
            
            ButtonView(action:{
                viewModel.pwdError = false
                viewModel.rePwdError = false
                viewModel.changePw()
            }, label: {
                Text("변경하기")
            }, boxColor: (viewModel.pwd.isEmpty || viewModel.newPwd.isEmpty || viewModel.rePwd.isEmpty) ? .gray400 : .key)
            .disabled(viewModel.pwd.isEmpty || viewModel.newPwd.isEmpty || viewModel.rePwd.isEmpty)
            .onChange(of: viewModel.changeSuccess, {
                if viewModel.changeSuccess {
                    router.pop()
                }
            })
            

        }
        .padding(.horizontal,41)
    }
}

#Preview {
    AccountManageView()
}
