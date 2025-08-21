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
    @Environment(NavigationRouter<MyhomeRoute>.self) private var router
    @StateObject private var viewModel = MyHomeViewModel()
    @FocusState private var isFocused: Bool
    @State private var showEditButton: Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var useDefaultImage: Bool = false
    @State var UsernameModal = false
    
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
            
            .fullScreenCover(isPresented: $viewModel.logoutSuccess) {
                LoginView()
            }
            if UsernameModal {
                ModalView {
                    VStack {
                        Text("닉네임 변경시 현재 계정에서 로그아웃 됩니다.")
                            .textStyle(.Button_s)
                        Spacer().frame(height:10)
                        Text("변경하시겠습니까?")
                            .textStyle(.Button_s)
                    }
                } leftButton: {
                    Button(action: {
                        UsernameModal.toggle()
                    }) {
                        Text("취소하기")
                    }
                } rightButton: {
                    Button(action: {
                        UsernameModal.toggle()
                        viewModel.validateAndSubmit()
                    }) {
                        Text("변경하기")
                    }
                }
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
                        router.pop()
                    }) {
                        Image(.iconBack)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if (viewModel.username != viewModel.originalUsername){
                            UsernameModal.toggle()
                        } else{
                            viewModel.validateAndSubmit()
                        }
                        if useDefaultImage {
                            viewModel.fetchDefaultImage()
                        } else if let data = selectedImageData {
                            viewModel.fetchProfileImage(imageData: data)
                        }
                    }) {
                        Text("완료")
                            .textStyle(.Q_Main)
                            .foregroundStyle(.highlight)
                            .underline()
                    }
                    .onChange(of: viewModel.changeSuccess) { oldValue, newValue in
                        if newValue {
                            router.pop()
                        }
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
            if let uiImage = viewModel.profileUIImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 124, height: 124)
                    .clipShape(Circle())
            } else if useDefaultImage {
                Image(.imgProfile)
                    .resizable()
                    .frame(width: 124, height: 124)
                    .clipShape(Circle())
            } else if let url = URL(string: viewModel.profileImageURL) {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 124, height: 124)
                    .clipShape(Circle())
            }
            
            Button(action: {
                showEditButton.toggle()
            }) {
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
                    Button(action: {
                        useDefaultImage = true
                        selectedImageData = nil
                    }) {
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
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Text("사진 불러오기")
                            .textStyle(.Q_pick)
                            .foregroundStyle(.black000)
                            .frame(width: 84, height: 25)
                            .background(RoundedRectangle(cornerRadius: 24).fill(.key))
                    }
                    .buttonStyle(.plain)
                    .onChange(of: selectedItem) { _, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                let paddedImage = uiImage.resizedWithPadding(targetSize: 124)
                                viewModel.profileUIImage = paddedImage
                                selectedImageData = paddedImage.jpegData(compressionQuality: 0.9)
                                useDefaultImage = false
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
            .textInputAutocapitalization(.never)
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
            .textInputAutocapitalization(.never)
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
