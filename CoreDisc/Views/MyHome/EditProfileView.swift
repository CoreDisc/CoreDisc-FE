//
//  EditProfileView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/16/25.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
                .onTapGesture { // 키보드 내리기 용도
                    isFocused = false
                }
            
            VStack(spacing: 0) {
                Spacer().frame(height: 3)
                
                TopMenuGroup
                
                ProfileGroup
                
                Spacer().frame(height: 34)
                
                TextfieldGroup
                
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
                Text("Edit Profile")
                    .textStyle(.Pick_Q_Eng)
                    .foregroundStyle(.gray200)
                
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(.iconBack)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) { // TODO: complete action
                        Text("완료")
                            .textStyle(.Q_Main)
                            .foregroundStyle(.highlight)
                            .underline()
                    }
                }
                .padding(.leading, 17)
                .padding(.trailing, 22)
            }
        }
    }
    
    // 프로필
    private var ProfileGroup: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle() // TODO: profile image
                .frame(width: 124, height: 124)
            
            Button(action: {}) { // TODO: profile edit
                Image(.iconEdit)
                    .frame(width: 38, height: 38)
                    .background(
                        Circle()
                            .fill(.gray400)
                    )
            }
            .buttonStyle(.plain)
        }
    }
    
    // 텍스트 필드
    private var TextfieldGroup: some View {
        VStack(spacing: 16) {
            ProfileEditTextField(type: "Nick Name", originalText: "닉네임")
                .focused($isFocused) // 키보드 내리기
            ProfileEditTextField(type: "User Name", originalText: "user_name")
                .focused($isFocused) // 키보드 내리기
        }
    }
}

// 프로필 수정용 텍스트필드
struct ProfileEditTextField: View {
    var type: String
    var originalText: String
    
    @State private var text: String = ""
    
    init(type: String, originalText: String) {
        self.type = type
        self.originalText = originalText
        _text = State(initialValue: originalText) // 텍스트필드 초기값 설정
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(type)
                .textStyle(.light_eng)
                .foregroundStyle(.gray200)
            
            Spacer().frame(width: 16)
            
            VStack(alignment: .leading, spacing: 2) {
                TextField(originalText,
                          text: $text,
                          prompt: Text(originalText).foregroundStyle(.gray600))
                    .textStyle(.Q_Main)
                    .foregroundStyle(.white)
                    .textInputAutocapitalization(.never)
                    .frame(maxWidth: 200)
                    .padding(.horizontal, 10)
                
                Divider()
                    .background(.gray200)
                    .frame(maxWidth: 200)
                
                if type == "User Name" {
                    Text("이미 존재하는 아이디입니다.")
                        .textStyle(.login_alert)
                        .foregroundStyle(.warning)
                }
            }
            
            Spacer().frame(width: 5)
            
            if type == "User Name" {
                Button(action: {}) { // TODO: 중복확인 action
                    Text("중복확인")
                        .textStyle(.Q_pick)
                        .foregroundStyle(.black000)
                        .frame(width: 63, height: 24)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.key)
                        )
                }
            } else {
                Spacer()
                    .frame(width: 63, height: 24)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 17)
    }
}

#Preview {
    EditProfileView()
}
