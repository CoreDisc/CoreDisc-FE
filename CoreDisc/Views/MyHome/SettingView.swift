//
//  SettingView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/17/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    
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
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
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
            SettingButton(title: "계정 관리") // TODO: 계정 관리 화면 전환
            SettingButton(title: "알림 설정", destination: { AnyView(NotificationView()) })
            SettingButton(title: "로그아웃") // TODO: 로그아웃 모달
        }
    }
}

// 설정 페이지 버튼
struct SettingButton: View {
    var title: String
    var destination: (() -> AnyView)?
    
    var body: some View {
        if let destination = destination {
            NavigationLink(destination: destination()) {
                buttonContent
            }
        } else {
            buttonContent
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
