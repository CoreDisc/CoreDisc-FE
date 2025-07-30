//
//  AccountManageView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/21/25.
//

import SwiftUI

struct AccountManageView: View {
    @Environment(\.dismiss) var dismiss
    @State var email: String = ""
    @State var id: String = ""
    @State var pwd: String = ""
    @State var newpwd: String = ""
    @State var repwd: String = ""
    
    @State private var pwdShown = false
    @State private var pwdError = false
    @State private var newPwdShown = false
    @State private var newPwdError = false
    @State private var rePwdShown = false
    @State private var rePwdError = false
    
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
        VStack(alignment: .leading){
            Text("이메일 변경")
                .textStyle(.A_Main)
                .foregroundStyle(.white)
            ZStack{
                InputView{
                    TextField("새로운 이메일을 입력해주세요.", text: $email)
                }
                HStack{
                    Spacer()
                    Button(action: {
                        print("중복확인")
                    }, label: {
                        ZStack{
                            Capsule()
                                .frame(width: 63, height: 25)
                                .foregroundStyle(.key)
                            Text("중복확인")
                                .textStyle(.Q_pick)
                                .foregroundStyle(.black000)
                        }
                        .padding(.horizontal)
                    })
                }
            }
            Spacer().frame(height:10)
            
            Text("아이디 변경")
                .textStyle(.A_Main)
                .foregroundStyle(.white)
            ZStack{
                InputView{
                    TextField("새로운 아이디를 입력해주세요.", text: $id)
                }
                HStack{
                    Spacer()
                    Button(action: {
                        print("중복확인")
                    }, label: {
                        ZStack{
                            Capsule()
                                .frame(width: 63, height: 25)
                                .foregroundStyle(.key)
                            Text("중복확인")
                                .textStyle(.Q_pick)
                                .foregroundStyle(.black000)
                        }
                        .padding(.horizontal)
                    })
                }
            }
            Spacer().frame(height:35)
            
            Text("비밀번호 변경")
                .textStyle(.A_Main)
                .foregroundStyle(.white)
            InputView{
                if pwdShown{
                    HStack{
                        TextField("현재 비밀번호를 입력해주세요.", text: $pwd)
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
                        SecureField("현재 비밀번호를 입력해주세요.", text: $pwd)
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
                        TextField("새로운 비밀번호를 입력해주세요.", text: $newpwd)
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
                        SecureField("새로운 비밀번호를 입력해주세요.", text: $newpwd)
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
            
            if newPwdError {
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
                        TextField("새로운 비밀번호를 한 번 더 입력해주세요.", text: $repwd)
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
                        SecureField("새로운 비밀번호를 한 번 더 입력해주세요.", text: $repwd)
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
            
            ButtonView(action:{print("변경하기")}, label: {
                Text("변경하기")
            }, boxColor: (email.isEmpty || pwd.isEmpty || newpwd.isEmpty || repwd.isEmpty || id.isEmpty) ? .gray400 : .key)
            .disabled(email.isEmpty || pwd.isEmpty || newpwd.isEmpty || repwd.isEmpty || id.isEmpty )
        
            Capsule()
                .frame(width: .infinity, height:1)
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
