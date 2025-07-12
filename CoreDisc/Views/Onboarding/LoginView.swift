//
//  LoginView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI


struct LoginView: View {
    @State var id: String = ""
    @State var pwd: String = ""
    
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
                Text("Shoot Your")
                    .textStyle(.Title_Text_Ko)
                    .foregroundStyle(.white)
                Text("Core.")
                    .textStyle(.Title_Text_Ko)
                    .foregroundStyle(.white)
                
                Spacer().frame(height: 16)
                MainGroup
                Spacer().frame(height: 43)
                SocialLoginGroup
            }
        }
        
    }
    private var MainGroup : some View{
        VStack{
            HStack{
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
                Text("로그인 또는 가입")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 24)
            
            ZStack{
                Capsule()
                    .frame(height: 40)
                    .foregroundStyle(.white)
                TextField("아이디", text: $id)
                    .textStyle(.login_info)
                    .padding(.leading, 31)
            }
            
            ZStack{
                Capsule()
                    .frame(height: 40)
                    .foregroundStyle(.white)
                SecureField("비밀번호", text: $pwd)
                    .textStyle(.login_info)
                    .padding(.leading, 31)
            }
            
            Spacer().frame(height: 36)

            Button(action:{}, label: {
                ZStack{
                    Rectangle()
                        .frame(height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.gray400)
                    Text("로그인")
                        .textStyle(.login_info)
                        .foregroundStyle(.black000)
                }
            })
            
            Spacer().frame(height: 37)
            
            HStack{
                Button(action:{}, label:{
                    Text("회원가입")
                        .textStyle(.login_info)
                        .underline()
                        .foregroundStyle(.highlight)
                })
                Spacer().frame(width: 32)
                Button(action:{}, label:{
                    Text("아이디/비밀번호 찾기")
                        .textStyle(.login_info)
                        .underline()
                        .foregroundStyle(.white)
                })
            }

        }.padding(.horizontal, 41)
    }
    private var SocialLoginGroup : some View{
        VStack{
            HStack{
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
                Text("간편 로그인")
                    .textStyle(.login_info)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                Divider()
                    .frame(width: 92, height: 1)
                    .background(Color.white)
            }
            
            Spacer().frame(height: 32)
            
            HStack{
//                Image(.naver)
                Spacer().frame(width: 43)
//                Image(.kakao)
                Spacer().frame(width: 43)
//                Image(.google)
            }
        }
        .padding(.horizontal, 41)
    }
}

#Preview {
    LoginView()
}
