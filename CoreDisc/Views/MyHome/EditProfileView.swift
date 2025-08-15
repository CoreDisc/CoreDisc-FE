//
//  EditProfileView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/16/25.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct EditProfileView: View {
    @StateObject private var viewModel = MyHomeViewModel()

    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    
    @State private var showEditButton: Bool = false

    
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
        .task {
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
                    
                    Button(action: {
                        viewModel.validateAndSubmit()
                    }) {
                        Text("완료")
                            .textStyle(.Q_Main)
                            .foregroundStyle(.highlight)
                            .underline()
                    }
                    .onChange(of: viewModel.changeSuccess) { oldValue, newValue in
                        if newValue {
                            dismiss()
                        }
                    }
                    .navigationDestination(isPresented: $viewModel.logoutSuccess) {LoginView()}
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
            } else {
                Circle()
                    .frame(width: 124, height: 124)
            }
            
            Button(action: {
                showEditButton.toggle()
            }) { // TODO: profile edit
                Image(.iconEdit)
                    .frame(width: 38, height: 38)
                    .background(
                        Circle()
                            .fill(.gray400)
                    )
            }
            .buttonStyle(.plain)
            
            if showEditButton {
                VStack(spacing: 12) {
                    Button(action: {}) { // TODO: 기본 이미지 설정
                        Text("기본 이미지")
                            .textStyle(.Q_pick)
                            .foregroundStyle(.black000)
                            .frame(width: 84, height: 25)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.key)
                            )
                    }
                    .buttonStyle(.plain)
                    
                    PhotosPicker(selection: $viewModel.selectedItems, maxSelectionCount: 1, matching: .images) {
                        Text("사진 불러오기")
                            .textStyle(.Q_pick)
                            .foregroundStyle(.black000)
                            .frame(width: 84, height: 25)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.key)
                            )
                    }
                    .buttonStyle(.plain)
                    .onChange(of: viewModel.selectedItems) {
                        guard let item = viewModel.selectedItems.first else { return }

                        Task {
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {

                                let paddedImage = uiImage.resizedWithPadding(targetSize: 124)

                                viewModel.profileUIImage = paddedImage

                                if let resizedData = paddedImage.jpegData(compressionQuality: 0.9) {
                                    viewModel.fetchProfileImage(imageData: resizedData)
                                }
                            }
                        }
                    }
                }
                .offset(x: 94)
            }
        }
    }
    
    // 텍스트 필드
    private var TextfieldGroup: some View {
        VStack(spacing: 16) {
            ProfileEditTextField(
                type: "Nick Name",
                text: $viewModel.nickname,
                duplicated: $viewModel.nameDuplicated,
                viewModel: viewModel
            )
                .focused($isFocused) // 키보드 내리기
                .onChange(of: viewModel.nickname) { oldValue, newValue in
                      if viewModel.nameCheckSuccess {
                          viewModel.nameCheckSuccess = false
                      }
                    viewModel.nextErrorNickname = false
                  }
            ProfileEditTextField(
                type: "User Name",
                text: $viewModel.username,
                duplicated: $viewModel.idDuplicated,
                viewModel: viewModel
            )
                .focused($isFocused) // 키보드 내리기
                .onChange(of: viewModel.username) { oldValue, newValue in
                      if viewModel.idCheckSuccess {
                          viewModel.idCheckSuccess = false
                      }
                    viewModel.nextErrorUsername = false
                  }
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
                .padding(.horizontal, 10)
                
                Divider()
                    .background(.gray200)
                    .frame(maxWidth: 200)
                
                if type == "User Name" {
                    if viewModel.nextErrorUsername {
                        Text("중복 확인을 해주세요.")
                            .textStyle(.login_alert)
                            .foregroundStyle(.warning)
                            .padding(.top, 2)
                    } else if duplicated {
                        Text("이미 존재하는 아이디입니다.")
                            .textStyle(.login_alert)
                            .foregroundStyle(.warning)
                            .padding(.top, 2)
                    } else if viewModel.idCheckSuccess {
                        Text("사용 가능한 아이디입니다.")
                            .textStyle(.login_alert)
                            .foregroundStyle(.white)
                            .padding(.top, 2)
                    }
                }
                
                if type == "Nick Name" {
                    if viewModel.nextErrorNickname {
                        Text("중복 확인을 해주세요.")
                            .textStyle(.login_alert)
                            .foregroundStyle(.warning)
                            .padding(.top, 2)
                    } else if duplicated {
                        Text("이미 존재하는 닉네임입니다.")
                            .textStyle(.login_alert)
                            .foregroundStyle(.warning)
                            .padding(.top, 2)
                    } else if viewModel.nameCheckSuccess {
                        Text("사용 가능한 닉네임입니다.")
                            .textStyle(.login_alert)
                            .foregroundStyle(.white)
                            .padding(.top, 2)
                    }
                    
                }
            
        }
        
        Spacer().frame(width: 5)
        
        Button(action: {
            if type == "User Name" {
                viewModel.fetchIdCheck(username: text)
                viewModel.nextErrorUsername = false
            } else {
                viewModel.fetchNameCheck()
                viewModel.nextErrorNickname = false
            }
        }) {
            if type == "User Name" {
                Text("중복확인")
                    .textStyle(.Q_pick)
                    .foregroundStyle(.black000)
                    .frame(width: 63, height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(viewModel.idCheckSuccess ? .gray400 : .key)
                    )
            } else{
                Text("중복확인")
                    .textStyle(.Q_pick)
                    .foregroundStyle(.black000)
                    .frame(width: 63, height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(viewModel.nameCheckSuccess ? .gray400 : .key)
                    )
            }
        }
        .padding(.top, 3)
    }

        .frame(maxWidth: .infinity)
        .padding(.horizontal, 17)
    }
}


#Preview {
    EditProfileView()
}
