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
            
            ButtonView(action:{}, label: {
                Text("인증 번호 전송")
            })
            
            Spacer().frame(height: 18)
            InputView{
                TextField("인증번호를 입력해주세요.", text: $auth)
            }
            
            
            ButtonView(action:{}, label: {
                Text("인증하기")
            })
            
            Spacer().frame(height: 18)
            
            
            InputView{
                SecureField("비밀번호를 입력해주세요.", text: $pwd)
            }
            Text("영문/숫자/특수문자(공백제외), 10~16자")
                .textStyle(.login_alert)
                .foregroundStyle(.gray400)
            
            InputView{
                SecureField("비밀번호를 한 번 더 입력해주세요.", text: $repwd)
            }
            
            Spacer().frame(height: 18)
            InputView{
                TextField("계정명을 입력해주세요.", text: $id)
            }
            
            Text("16자 이내 영문,숫자,특수문자(_,.)만 사용 가능합니다.")
                .textStyle(.login_alert)
                .foregroundStyle(.gray400)
            
            InputView{
                TextField("이름을 입력해주세요.", text: $name)
            }
            
            Text("16자 이내 영문,한글만 사용 가능합니다.")
                .textStyle(.login_alert)
                .foregroundStyle(.gray400)
            
            Spacer().frame(height: 22)
            
            ButtonView(action:{}, label: {
                Text("가입하기")
            })
        }
        .padding(.horizontal, 41)
    }
}

#Preview {
    SignupView()
}
