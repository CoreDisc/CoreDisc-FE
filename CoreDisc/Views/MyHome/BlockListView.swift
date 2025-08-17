//
//  BlockListView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/21/25.
//

import SwiftUI
import Kingfisher

struct BlockListView: View {
    @Environment(NavigationRouter<MyhomeRoute>.self) private var router
    
    @StateObject var userViewModel = UserHomeViewModel()
    @StateObject private var viewModel = BlockListViewModel()
    
    @State var showUnblockModal: Bool = false
    @State var blockedUserId: Int = 0
    
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
                        userViewModel.fetchUnblock(targetId: blockedUserId) {
                            viewModel.fetchBlockList()
                        }
                        showUnblockModal.toggle() // 차단해제모달 제거
                    }) {
                        Text("차단 해제하기")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .task {
            viewModel.fetchBlockList()
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
    
    // 리스트
    private var ListGroup: some View {
        ZStack {
            // 배경
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray600)
            
            ScrollView {
                VStack(spacing: 16) {
                    let list = viewModel.blockList
                    ForEach(list, id: \.blockedId) { item in
                        BlockListItem(
                            item: item,
                            blockedUserId: $blockedUserId,
                            showUnblockModal: $showUnblockModal
                        ) // TODO: API 커서
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
    let item: BlockListValue
    
    @Binding var blockedUserId: Int
    @Binding var showUnblockModal: Bool
    
    var body: some View {
        HStack(spacing: 11) {
            if let url = URL(string: item.profileImgDTO.imageUrl) {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(item.blockedNickname)
                    .textStyle(.Button_s)
                    .foregroundStyle(.gray100)
                
                Text("@\(item.blockedUsername)")
                    .textStyle(.Pick_Q_Eng)
                    .foregroundStyle(.gray100)
            }
            
            Spacer()
            
            Button(action: {
                blockedUserId = item.blockedId
                showUnblockModal = true
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
