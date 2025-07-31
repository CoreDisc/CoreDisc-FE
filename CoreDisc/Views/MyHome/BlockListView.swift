//
//  BlockListView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/21/25.
//

import SwiftUI

struct BlockListView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = BlockListViewModel()
    
    @State var showUnblockModal: Bool = false
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 3)
                
                TopMenuGroup
                
                ListGroup
            }
            
            // 차단 해제 모달
            if showUnblockModal {
                ModalView {
                    VStack(spacing: 10) {
                        Text("차단을 해제하면 서로의 활동을 다시 볼 수 있습니다.")
                            .textStyle(.Button_s)
                        
                        Text("차단 해제하시겠습니까?")
                            .textStyle(.Button_s)
                    }
                } leftButton: {
                    Button(action: {
                        showUnblockModal.toggle() // 차단해제모달 제거
                    }) {
                        Text("취소하기")
                    }
                } rightButton: {
                    Button(action: {
                        showUnblockModal.toggle() // 차단해제모달 제거
                        // TODO: unblock api
                    }) {
                        Text("차단 해제하기")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
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
                Text("차단 목록")
                    .textStyle(.Button)
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
    
    // 리스트
    private var ListGroup: some View {
        ZStack {
            // 배경
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray600)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.blockSample, id: \.blockedId) { item in
                        BlockListItem(nickname: item.blockedNickname, username: item.blockedUsername, showUnblockModal: $showUnblockModal)
                    }
                }
                .padding(.top, 39)
                .padding(.bottom, 90) // 탭바에 가려지지 않게
            }
        }
        .padding(.horizontal, 14)
    }
}

// MARK: - component
struct BlockListItem: View {
    var nickname: String
    var username: String
    
    @Binding var showUnblockModal: Bool
    
    var body: some View {
        HStack(spacing: 11) {
            Circle() // TODO: user profile image
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(nickname)
                    .textStyle(.Button_s)
                    .foregroundStyle(.gray100)
                
                Text("@\(username)")
                    .textStyle(.Pick_Q_Eng)
                    .foregroundStyle(.gray100)
            }
            
            Spacer()
            
            Button(action: {
                showUnblockModal = true
                // TODO: unblock api
            }) {
                Text("unblock")
                    .textStyle(.Button_s)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray800)
                    )
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 23)
        .padding(.bottom, 14)
    }
}

#Preview {
    BlockListView()
}
