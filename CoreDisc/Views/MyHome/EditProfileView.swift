//
//  EditProfileView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/16/25.
//

import SwiftUI
import Kingfisher

struct EditProfileView: View {
    @StateObject private var viewModel = MyHomeViewModel()

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
        .onAppear {
            viewModel.fetchMyHome()
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
            if let url = URL(string: viewModel.profileImageURL) {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 124, height: 124)
                    .clipShape(Circle())
            }
            
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
            ProfileEditTextField(
                type: "Nick Name",
                text: $viewModel.nickname,
                duplicated: .constant(false),
                viewModel: viewModel
            )
                .focused($isFocused) // 키보드 내리기
            ProfileEditTextField(
                type: "User Name",
                text: $viewModel.username,
                duplicated: $viewModel.duplicated,
                viewModel: viewModel
            )
                .focused($isFocused) // 키보드 내리기
        }
    }
}

// 프로필 수정용 텍스트필드
struct ProfileEditTextField: View {
    var type: String
    @Binding var text: String
    @Binding var duplicated: Bool
    @ObservedObject var viewModel: MyHomeViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(type)
                .textStyle(.Pick_Q_Eng)
                .foregroundStyle(.gray200)
                .padding(.vertical, 8)
            
            Spacer().frame(width: 16)
            
            VStack(alignment: .leading, spacing: 0) {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(type).foregroundStyle(.gray600)
                )
                    .textStyle(.Pick_Q_Eng)
                    .foregroundStyle(.white)
                    .textInputAutocapitalization(.never)
                    .frame(height: 28)
                    .frame(maxWidth: 200)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
                
                Divider()
                    .background(.gray200)
                    .frame(maxWidth: 200)
                
                if type == "User Name", duplicated {
                    Text("이미 존재하는 아이디입니다.")
                        .textStyle(.login_alert)
                        .foregroundStyle(.warning)
                        .padding(.top, 2)
                } else if type == "User Name", !duplicated {
                    Text("사용 가능한 아이디입니다.")
                        .textStyle(.login_alert)
                        .foregroundStyle(.white)
                        .padding(.top, 2)
                }
            }
            
            Spacer().frame(width: 5)
            
            if type == "User Name" {
                Button(action: {
                    viewModel.fetchIdCheck(username: text)
                }) {
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
