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
            
            VStack {
                TopMenuGroup
                
                Spacer()
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
}

#Preview {
    NotificationView()
}
