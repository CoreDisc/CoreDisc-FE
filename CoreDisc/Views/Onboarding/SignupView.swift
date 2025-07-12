//
//  SignupView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/11/25.
//

import SwiftUI

struct SignupView: View {
    
    @State var email: String = ""
    @State var auth: String = ""
    @State var pwd: String = ""
    @State var repwd: String = ""
    @State var id: String = ""
    @State var name: String = ""
    
    var body: some View {
        ZStack {
//            Image(.background)
//                .aspectRatio(contentMode: .fill)
//                .ignoresSafeArea()
            VStack{
                Rectangle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.key)
                Spacer().frame(height: 16)
                MainGroup
            }
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

            ZStack{
                Capsule()
                    .frame(height: 40)
                    .foregroundStyle(.white)
                TextField("이메일을 입력해주세요.", text: $email)
                    .textStyle(.login_info)
                    .padding(.leading, 31)
            }
            
            Button(action:{}, label: {
                ZStack{
                    Rectangle()
                        .frame(height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.gray400)
                    Text("인증 번호 전송")
                        .textStyle(.login_info)
                        .foregroundStyle(.black000)
                }
            })
            
        Spacer().frame(height: 18)
            
            ZStack{
                Capsule()
                    .frame(height: 40)
                    .foregroundStyle(.white)
                TextField("인증번호를 입력해주세요.", text: $auth)
                    .textStyle(.login_info)
                    .padding(.leading, 31)
            }
            
            Button(action:{}, label: {
                ZStack{
                    Rectangle()
                        .frame(height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.gray400)
                    Text("인증하기")
                        .textStyle(.login_info)
                        .foregroundStyle(.black000)
                }
            })
            
        Spacer().frame(height: 18)
            
            ZStack{
                Capsule()
                    .frame(height: 40)
                    .foregroundStyle(.white)
                SecureField("비밀번호를 입력해주세요.", text: $pwd)
                    .textStyle(.login_info)
                    .padding(.leading, 31)
            }
            
            Text("영문/숫자/특수문자(공백제외), 10~16자")
                .textStyle(.login_alert)
                .foregroundStyle(.gray400)
            
            ZStack{
                Capsule()
                    .frame(height: 40)
                    .foregroundStyle(.white)
                SecureField("비밀번호를 한 번 더 입력해주세요.", text: $repwd)
                    .textStyle(.login_info)
                    .padding(.leading, 31)
            }
            
        Spacer().frame(height: 18)
            
            ZStack{
                Capsule()
                    .frame(height: 40)
                    .foregroundStyle(.white)
                TextField("계정명을 입력해주세요.", text: $id)
                    .textStyle(.login_info)
                    .padding(.leading, 31)
            }
            
            Text("16자 이내 영문,숫자,특수문자(_,.)만 사용 가능합니다.")
                .textStyle(.login_alert)
                .foregroundStyle(.gray400)
            
            
            ZStack{
                Capsule()
                    .frame(height: 40)
                    .foregroundStyle(.white)
                TextField("이름을 입력해주세요.", text: $name)
                    .textStyle(.login_info)
                    .padding(.leading, 31)
            }
            
            Text("16자 이내 영문,한글만 사용 가능합니다.")
                .textStyle(.login_alert)
                .foregroundStyle(.gray400)
            
        Spacer().frame(height: 22)
            
            Button(action:{}, label: {
                ZStack{
                    Rectangle()
                        .frame(height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.gray400)
                    Text("가입하기")
                        .textStyle(.login_info)
                        .foregroundStyle(.black000)
                }
            })
        }
        .padding(.horizontal, 41)
    }
}

#Preview {
    SignupView()
}
