//
//  AccountManageView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/21/25.
//

import SwiftUI

struct AccountManageView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AccountManageViewModel()
    @State private var pwdShown = false
    @State private var newPwdShown = false
    @State private var rePwdShown = false
    @State var WithdrawModal = false
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            
            VStack{
                TopMenuGroup
                Spacer().frame(height: 13)
                MainGroup
                Spacer()
            }
            
            if WithdrawModal {
                ModalView {
                    VStack(spacing: 10) {
                        Text("계정 탈퇴시 지금까지의 모든 데이터가 삭제됩니다.")
                            .textStyle(.Button_s)
                        
                        Text("탈퇴하시겠습니까?")
                            .textStyle(.Button_s)
                    }
                } leftButton: {
                    Button(action: {
                        WithdrawModal.toggle()
                    }) {
                        Text("취소하기")
                    }
                } rightButton: {
                    Button(action: {
                        WithdrawModal.toggle()
                    }) {
                        Text("탈퇴하기")
                            .foregroundStyle(.red)
                    }
                }
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
                Text("계정 관리")
                    .textStyle(.Button)
                    .foregroundStyle(.gray200)
                
                HStack {
                    Button(action: {
                        dismiss()
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
        VStack(alignment: .leading) {
            
            Text("비밀번호 변경")
                .textStyle(.A_Main)
                .foregroundStyle(.white)
            InputView{
                if pwdShown{
                    HStack{
                        TextField("현재 비밀번호를 입력해주세요.", text: $viewModel.pwd)
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
            }, boxColor: viewModel.email.isEmpty &&
                       viewModel.id.isEmpty &&
                       (viewModel.pwd.isEmpty || viewModel.newPwd.isEmpty || viewModel.rePwd.isEmpty) ? .gray400 : .key)
            .disabled(viewModel.email.isEmpty &&
                      viewModel.id.isEmpty &&
                      (viewModel.pwd.isEmpty || viewModel.newPwd.isEmpty || viewModel.rePwd.isEmpty) )
            .onChange(of: viewModel.changeSuccess, {
                if viewModel.changeSuccess {
                    dismiss()
                }
            })
            
            Capsule()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundStyle(.white)
                .padding(.vertical, 24)
            
            Button(action:{WithdrawModal = true}, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.warning, lineWidth: 1)
                        .frame(height: 40)
                    Text("계정 삭제")
                        .frame(maxWidth: .infinity)
                        .textStyle(.Button_s)
                        .foregroundStyle(.warning)
                }
            })
        }
        .padding(.horizontal,41)
    }
}

#Preview {
    AccountManageView()
}
