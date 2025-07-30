//
//  FindPwView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/11/25.
//

import SwiftUI

struct FindPwView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    @State var id: String = ""
    @State var auth: String = ""
    @State var pwd: String = ""
    @State var rePwd: String = ""
    @State private var find = "input"
    
    var body: some View {
        ZStack {
            Image(.imgOnboardingBackground)
                .resizable()
                .ignoresSafeArea()

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
                
                if find == "input" {
                    InputGroup
                } else if find == "auth" {
                    AuthGroup
                } else {
                    ChangeGroup
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
    private var InputGroup : some View{
        VStack{
            HStack{
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
                Text("비밀번호 찾기")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 26)
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 24)
            
            InputView{
                TextField("이름", text: $name)
            }
            
            InputView{
                TextField("아이디", text: $id)
            }
            
            Spacer().frame(height: 36)

            
            ButtonView(action:{find = "auth"}, label: {
                Text("인증번호 발송하기")
            })
            
            Spacer().frame(height: 12)
            
            NavigationLink(destination: LoginView()) {
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
                    .frame(width: 92, height: 1)
                    .background(Color.white)
                Text("비밀번호 찾기")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 26)
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 24)

            InputView{
                TextField("인증번호 6자리", text: $auth)
            }
            
            Text("계정에 등록된 이메일로 인증번호가 전송되었습니다.")
                .textStyle(.login_alert)
                .foregroundStyle(.highlight)
            
            Spacer().frame(height: 72)

            ButtonView(action:{find = "changePw"}, label: {
                Text("인증하기")
            })
            
            Spacer().frame(height: 12)
            
            NavigationLink(destination: LoginView()) {
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
                    .frame(width: 92, height: 1)
                    .background(Color.white)
                Text("비밀번호 찾기")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 26)
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 24)
            
            InputView{
                SecureField("비밀번호를 입력해주세요.", text: $pwd)
            }
            
            Text("영문/숫자/특수문자(공백제외), 10~16자")
                .textStyle(.login_alert)
                .foregroundStyle(.gray400)
            
            InputView{
                SecureField("비밀번호를 한 번 더 입력해주세요.", text: $rePwd)
            }
            
            Spacer().frame(height: 36)
            
            ButtonView(action:{}, label: {
                Text("변경하기")
            })
            
            Spacer().frame(height: 12)
            
            NavigationLink(destination: LoginView()) {
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
