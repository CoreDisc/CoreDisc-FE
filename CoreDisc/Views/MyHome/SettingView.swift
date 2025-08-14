//
//  SettingView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/17/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @State var LogoutModal = false
    @StateObject private var viewModel = AccountManageViewModel()
    
    var body: some View {
        NavigationStack{
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
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $viewModel.logoutSuccess) {LoginView()}
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
    
    // 버튼
    private var ButtonGroup: some View {
        VStack(spacing: 18) {
            SettingButton(title: "계정 관리", destination: { AnyView(AccountManageView()) })
            SettingButton(title: "차단 유저 목록", destination: { AnyView(BlockListView()) })
            SettingButton(title: "알림 설정", destination: { AnyView(NotificationView()) })
            SettingButton(title: "로그아웃", onClick: { LogoutModal = true })
        }
    }
}

// 설정 페이지 버튼
struct SettingButton: View {
    var title: String
    var destination: (() -> AnyView)?
    var onClick: (() -> Void)?
    
    var body: some View {
        if let destination = destination {
            NavigationLink(destination: destination()) {
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
        .padding(.horizontal, 38)
    }
}

#Preview {
    SettingView()
}
