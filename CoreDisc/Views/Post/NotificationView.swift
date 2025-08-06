//
//  NotificationView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/6/25.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                NotificationDate(date: "2025-08-01")
                
                ForEach(1..<10, id: \.self) { item in
                    NotificationListItem()
                }
            }
        }
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
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.gray200)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
            
            HStack(spacing: 18) {
                Circle() // TODO: Profile Image
                    .frame(width: 36, height: 36)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("@Coredisc.ko님이 게시글에 댓글을 남겼어요.")
                        .textStyle(.A_Main)
                        .foregroundStyle(.black000)
                    Text("5분 전")
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

#Preview {
    NotificationView()
}
