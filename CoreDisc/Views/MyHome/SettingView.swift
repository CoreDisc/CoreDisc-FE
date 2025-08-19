//
//  SettingView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/17/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(NavigationRouter<MyhomeRoute>.self) private var router
    
    @State var LogoutModal = false
    @StateObject private var viewModel = AccountManageViewModel()
    @State var WithdrawModal = false
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 3)
                
                TopMenuGroup
                
                Spacer().frame(height: 34)
                
                ButtonGroup
                
                Spacer()
            }
            if LogoutModal {
                ModalView {
                    VStack {
                        Text("로그아웃 하시겠습니까?")
                            .textStyle(.Button_s)
                    }
                } leftButton: {
                    Button(action: {
                        LogoutModal.toggle()
                    }) {
                        Text("돌아가기")
                    }
                } rightButton: {
                    Button(action: {
                        LogoutModal.toggle()
                        viewModel.logout()
                    }) {
                        Text("로그아웃")
                            .foregroundStyle(.red)
                    }
                }
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
                        viewModel.resign()
                    }) {
                        Text("탈퇴하기")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .task {
            viewModel.getSocial()
        }
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $viewModel.logoutSuccess) {LoginView()}
    }
    
    // 상단 메뉴
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
                Text("Setting")
                    .textStyle(.Pick_Q_Eng)
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
    
    // 버튼
    private var ButtonGroup: some View {
        VStack(spacing: 18) {
            Button(action: {
                if viewModel.isSocialUser {
                    ToastManager.shared.show("소셜 로그인 시 비밀번호 변경은 불가합니다")
                } else {
                    router.push(.account)
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray400)
                        .frame(height: 54)
                    
                    HStack {
                        Spacer().frame(width: 16)
                        
                        Text("비밀번호 변경")
                            .textStyle(.Button_s)
                            .foregroundStyle(.black000)
                        
                        Spacer()
                        Image(.iconButtonArrow)
                    }
                    .padding(.horizontal, 9)
                }
            }
            SettingButton(title: "차단 유저 목록", destination: .block)
            SettingButton(title: "알림 설정", destination: .notification)
            SettingButton(title: "로그아웃", onClick: { LogoutModal = true })
            
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
        .padding(.horizontal, 38)
    }
}

// 설정 페이지 버튼
struct SettingButton: View {
    @Environment(NavigationRouter<MyhomeRoute>.self) private var router
    
    var title: String
    var destination: MyhomeRoute?
    var onClick: (() -> Void)?
    
    var body: some View {
        if let destination = destination {
            Button(action: {
                router.push(destination)
            }) {
                buttonContent
            }
        } else {
            Button(action: {
                onClick?()
            }) {
                buttonContent
            }
        }
    }
    
    private var buttonContent: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray400)
                .frame(height: 54)
            
            HStack {
                Spacer().frame(width: 16)
                
                Text(title)
                    .textStyle(.Button_s)
                    .foregroundStyle(.black000)
                
                Spacer()
                
                if title != "로그아웃" {
                    Image(.iconButtonArrow)
                }
            }
            .padding(.horizontal, 9)
        }
    }
}

#Preview {
    SettingView()
}
