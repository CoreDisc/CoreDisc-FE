//
//  NotificationView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/20/25.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) var dismiss
    
    // 토글 상태
    @State private var firstToggleOn: Bool = false
    @State private var secondToggleOn: Bool = false

    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 3)
                
                TopMenuGroup
                
                ToggleGroup
                
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
                Text("알림 설정")
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
    
    // 질문 알림 수신
    private var ToggleGroup: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("질문 알림 수신")
                .textStyle(.A_Main)
                .foregroundStyle(.white)
                .padding(.leading, 6)
            
            Spacer().frame(height: 8)
            
            NotificationToggleBox(title: "첫 번째 재알림", isOn: $firstToggleOn, isActive: .constant(true))
            
            Spacer().frame(height: 11.6)
            
            NotificationToggleBox(title: "두 번째 재알림", isOn: $secondToggleOn, isActive: $firstToggleOn)
        }
        .padding(.horizontal, 38)
    }
    
    // 질문 알림 수신
}

// MARK: - components
// 알림 토글 박스
struct NotificationToggleBox: View {
    var title: String
    @Binding var isOn: Bool
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray600)
                .frame(height: 54.3)
                
            HStack {
                Text(title)
                    .textStyle(.Button_s)
                    .foregroundStyle(.gray200)
                    .padding(.leading, 13)
                
                Spacer()
                
                NotificationToggle(isOn: $isOn, isActive: $isActive)
            }
            .padding(.horizontal, 12)
        }
    }
}

// 알림 토글
struct NotificationToggle: View {
    @Binding var isOn: Bool
    @Binding var isActive: Bool
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isOn.toggle()
            }
        }) {
            ZStack(alignment: isOn ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isOn ? .black000 : .gray800)
                    .stroke(isActive ? .white : .black000, lineWidth: 1)
                    .frame(width: 70, height: 33)
                
                Text(isOn ? "On" : "Off")
                    .textStyle(.Button_s)
                    .foregroundStyle(isActive ? .black000 : .gray600)
                    .frame(width: 27, height: 27)
                    .background {
                        Circle()
                            .fill(isOn ? .key : .gray400)
                    }
                    .padding(.horizontal, 3)
            }
        }
        .disabled(!isActive)
    }
}

// 알림 시간

#Preview {
    NotificationView()
}
