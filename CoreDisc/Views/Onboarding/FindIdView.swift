//
//  FindIdView.swift
//  CoreDisc
//
//  Created by 정서영 on 7/11/25.
//

import SwiftUI


struct FindIdView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var email: String = ""
    @State private var find = false
    
    var body: some View {
        ZStack {
            Image(.imgOnboardingBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack{
                Spacer().frame(height: 96)
                Rectangle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.key)
                Spacer().frame(height: 16)
                Text("Shoot Your")
                    .textStyle(.Title_Text_Ko)
                    .foregroundStyle(.white)
                Text("Core.")
                    .textStyle(.Title_Text_Ko)
                    .foregroundStyle(.white)
                
                Spacer().frame(height: 16)
                
                if find {
                    FindGroup
                } else {
                    InputGroup
                }
                Spacer()
            }
        }
        
    }
    private var InputGroup : some View{
        VStack{
            HStack{
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
                Text("아이디 찾기")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 31)
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 24)
            
            InputView{
                TextField("이름", text: $name)
            }
            
            InputView{
                TextField("이메일", text: $email)
            }
            
            Spacer().frame(height: 36)

            ButtonView(action:{find = true}, label: {
                Text("아이디 찾기")
            })

            ButtonView(action:{dismiss()}, label: {
                Text("로그인 화면으로 돌아가기")
            })
            
            Spacer().frame(height: 54)
            
            HStack{
                NavigationLink(destination: SignupView()) {
                    Text("회원가입")
                        .textStyle(.login_info)
                        .underline()
                        .foregroundStyle(.highlight)
                }
                
                Spacer().frame(width: 32)
                
                NavigationLink(destination: FindPwView()) {
                    Text("비밀번호 찾기")
                        .textStyle(.login_info)
                        .underline()
                        .foregroundStyle(.white)
                }
            }

        }.padding(.horizontal, 41)
    }
    
    private var FindGroup : some View{
        VStack{
            HStack{
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
                Text("아이디 찾기")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 31)
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 29)
            
            Text("아이디는")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
            Text("coredisc_Ko")
                .textStyle(.Id_Find)
                .foregroundStyle(.white)
                .padding(.vertical, 10)
            Text("입니다.")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
            
            Spacer().frame(height: 29)

            ButtonView(action:{}, label: {
                Text("비밀번호 찾기")
            })
            
            ButtonView(action:{dismiss()}, label: {
                Text("로그인 화면으로 돌아가기")
            })
            
            Spacer().frame(height: 54)
            
            HStack{
                Button(action:{}, label:{
                    Text("회원가입")
                        .textStyle(.login_info)
                        .underline()
                        .foregroundStyle(.highlight)
                })
                Spacer().frame(width: 32)
                Button(action:{}, label:{
                    Text("비밀번호 찾기")
                        .textStyle(.login_info)
                        .underline()
                        .foregroundStyle(.white)
                })
            }

        }.padding(.horizontal, 41)
    }
}

#Preview {
    FindIdView()
}
