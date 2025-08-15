//
//  NotificationView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/20/25.
//

import SwiftUI

struct NotificationSettingView: View {
    @StateObject var viewModel = NotificationSettingViewModel()
    @Environment(\.dismiss) var dismiss
    
    // 시간
    @State var showSheet: Bool = false
    
    // TODO: 토글에 따라 시간 버튼 활성화/비활성화 처리
    // TODO: 바텀시트 배경 비활성화 처리

    var body: some View {
        ZStack {
            Image(.imgShortBackground2)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 3)
                
                TopMenuGroup
                
                Spacer().frame(height: 13)
                
                ToggleGroup
                
                Spacer().frame(height: 11.6)
                
                TimeGroup
                
                Spacer()
            }
            
            if showSheet {
                TimePickerSheet(showSheet: $showSheet, timeType: viewModel.timeType)
                    .environmentObject(viewModel)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showSheet)
        .toolbarVisibility(.hidden, for: .navigationBar)
        .task {
            viewModel.fetchReminderState()
        }
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
            
            NotificationToggleBox(viewModel: viewModel, title: "첫 번째 재알림", isOn: $viewModel.firstOn, isActive: true)
            
            Spacer().frame(height: 11.6)
            
            NotificationToggleBox(viewModel: viewModel, title: "두 번째 재알림", isOn: $viewModel.secondOn, isActive: viewModel.isSecondToggleActive)
        }
        .padding(.horizontal, 38)
    }
    
    // 질문 알림 시간
    private var TimeGroup: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("질문 알림 시간")
                .textStyle(.A_Main)
                .foregroundStyle(.white)
                .padding(.leading, 6)
            
            Spacer().frame(height: 8)
            
            NotificationTimeBox(
                title: "첫 번째 재알림 시간",
                timeType: .first,
                showSheet: $showSheet,
                isActive: viewModel.isFirstTimeActive
            )
            .environmentObject(viewModel)
            
            Spacer().frame(height: 11.6)
            
            NotificationTimeBox(
                title: "두 번째 재알림 시간",
                timeType: .second,
                showSheet: $showSheet,
                isActive: viewModel.isSecondTimeActive
            )
            .environmentObject(viewModel)
        }
        .padding(.horizontal, 38)
    }
}

// MARK: - components
// 알림 토글 박스
struct NotificationToggleBox: View {
    @ObservedObject var viewModel: NotificationSettingViewModel
    var title: String
    @Binding var isOn: Bool
    var isActive: Bool
    
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
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isOn.toggle()
                        
                        // 첫번쨰 off면 두번째도 자동 off
                        if title == "첫 번째 재알림", isOn == false {
                            viewModel.secondOn = false
                        }
                        
                        let data: NotificationData
                        if title == "첫 번째 재알림" {
                            data = NotificationData(
                                dailyReminderEnabled: isOn,
                                dailyReminderHour: viewModel.data.dailyReminderHour,
                                dailyReminderMinute: viewModel.data.dailyReminderMinute,
                                unansweredReminderEnabled: viewModel.data.unansweredReminderEnabled,
                                unansweredReminderHour: viewModel.data.unansweredReminderHour,
                                unansweredReminderMinute: viewModel.data.unansweredReminderMinute
                            )
                        } else {
                            data = NotificationData(
                                dailyReminderEnabled: viewModel.data.dailyReminderEnabled,
                                dailyReminderHour: viewModel.data.dailyReminderHour,
                                dailyReminderMinute: viewModel.data.dailyReminderMinute,
                                unansweredReminderEnabled: isOn,
                                unansweredReminderHour: viewModel.data.unansweredReminderHour,
                                unansweredReminderMinute: viewModel.data.unansweredReminderMinute
                            )
                        }
                        viewModel.fetchSetReminder(notificationData: data)

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
            .padding(.horizontal, 12)
        }
    }
}

// 알림 시간 박스
struct NotificationTimeBox: View {
    @EnvironmentObject var viewModel: NotificationSettingViewModel
    
    var title: String
    var timeType: TimeType
    @Binding var showSheet: Bool
    var isActive: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray600)
                .frame(height: 54.3)
                
            HStack {
                Text(title)
                    .textStyle(.Button_s)
                    .foregroundStyle(.gray200)
                    .padding(.leading, 6)
                
                Spacer()
                
                // 시간
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray400)
                        .frame(width: 60, height: 24)
                    
                    Button(action: {
                        viewModel.timeType = timeType
                        showSheet = true
                    }) {
                        switch timeType {
                        case .first:
                            Text("\(String(format: "%02d", viewModel.data.dailyReminderHour)) : \(String(format: "%02d", viewModel.data.dailyReminderMinute))")
                                .textStyle(.Q_Main)
                                .foregroundStyle(isActive ? .black000 : .gray600)
                        case .second:
                            Text("\(String(format: "%02d", viewModel.data.unansweredReminderHour)) : \(String(format: "%02d", viewModel.data.unansweredReminderMinute))")
                                .textStyle(.Q_Main)
                                .foregroundStyle(isActive ? .black000 : .gray600)
                        }
                    }
                    .disabled(!isActive)
                }
            }
            .padding(.horizontal, 19)
        }
    }
}

#Preview {
    NotificationSettingView()
        .environmentObject(NotificationSettingViewModel())
}
