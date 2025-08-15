//
//  NotificationView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/6/25.
//

import SwiftUI
import Kingfisher

struct NotificationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = NotificationViewModel()
    @StateObject var mainViewModel = QuestionMainViewModel()
    
    @State private var selectedItem: NotificationValues?
    
    var body: some View {
        ZStack{
            Image(.imgPostDetailMainBg)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 11) {
                TopMenuGroup
                
                NotificationList
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            viewModel.refresh()
        }
        .refreshable { // 당겨서 새로고침
            viewModel.refresh()
        }
        .navigationDestination(item: $selectedItem) { item in
            switch item.type {
            case "FOLLOW":
                UserHomeView(userName: item.senderNickname)
            case "SHARED_SAVED":
                EmptyView()
//                QuestionShareNowView()
            case "COMMEND", "COMMENT_REPLY", "LIKE":
                PostDetailView(postId: item.targetId)
            case "TEMP_POSTS":
                PostWriteView()
            case "DAILY_REMINDER", "UNANSWERED_REMINDER":
                QuestionMainView()
            case "DAILY_REMINDER_ANSWER", "UNANSWERED_REMINDER_ANSWER":
                PostWriteView()
            default:
                EmptyView()
            }
        }
    }
    
    // 상단 메뉴
    private var TopMenuGroup: some View {
        ZStack {
            Text("Notification")
                .textStyle(.Pick_Q_Eng)
                .foregroundStyle(.black000)
                .padding(.top, 4)
            
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(.iconBack)
                }
                
                Spacer()
            }
            .padding(.leading, 17)
        }

    }
    
    // 알림 리스트
    private var NotificationList: some View {
        ScrollView {
            LazyVStack(spacing: 23) {
                ForEach(viewModel.groupedNotifications, id: \.date) { group in
                    NotificationDate(date: group.date)
                    
                    ForEach(group.values, id: \.notificationId) { item in
                        NotificationListItem(viewModel: viewModel, item: item) {
                            selectedItem = item
                            if !item.isRead {
                                viewModel.fetchRead(notificationId: item.notificationId)
                            }
                        }
                        .task {
                            viewModel.loadNextPageIfNeeded(currentItem: item)
                        }
                    }
                }
            }
            .padding(.bottom, 75)
        }
        .scrollIndicators(.hidden)
    }
}

// 날짜
struct NotificationDate: View {
    var date: String
    
    var body: some View {
        HStack {
            Text(date)
                .textStyle(.A_Main)
                .foregroundStyle(.white)
                .frame(width: 88, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.clear)
                        .strokeBorder(.white, lineWidth: 1)
                )
                .padding(.leading, 33)
            
            Spacer()
        }
    }
}

// 알림 리스트 아이템
struct NotificationListItem: View {
    @ObservedObject var viewModel: NotificationViewModel
    
    var item: NotificationValues
    var onTap: () -> Void
    
    var body: some View {
        Button(action: {
            if !item.isRead {
                viewModel.fetchRead(notificationId: item.notificationId)
            }
            onTap()
        }) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(item.isRead ? .gray200 : .highlight)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                
                HStack(spacing: 18) {
                    if let imageUrl = item.profileImgDTO.imageUrl,
                       let url = URL(string: imageUrl) {
                        KFImage(url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(.gray400)
                            .frame(width: 36, height: 36)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.content)
                            .textStyle(.A_Main)
                            .foregroundStyle(.black000)
                        Text(item.timeStamp)
                            .textStyle(.Small_Text_10)
                            .foregroundStyle(.black000)
                    }
                }
                .padding(.leading, 28)
            }
            .frame(height: 63)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    NotificationView()
}
