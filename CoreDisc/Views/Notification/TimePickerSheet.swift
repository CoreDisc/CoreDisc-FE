//
//  TimePickerSheet.swift
//  CoreDisc
//
//  Created by 김미주 on 7/21/25.
//

import SwiftUI

struct TimePickerSheet: View {
    @Binding var showSheet: Bool
    @EnvironmentObject var viewModel: NotificationSettingViewModel
    
    var timeType: TimeType

    @State private var selectedHour = 8
    @State private var selectedMinute: Int = 0
    
    // 전체 시간
    let hours = Array(0...23) // 0시 ~ 23시
    let minutes = stride(from: 0, to: 60, by: 5).map { $0 } // 0분 ~ 60분 (5분 간격)
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.black000)
                    .shadow(color: .black000, radius: 5, x: 0, y: 0)
                
                VStack(spacing: 0) {
                    TopGroup
                    
                    Spacer().frame(height: 40)
                    
                    TimePickerGroup
                    
                    Spacer()
                    
                    // 설정 버튼
                    Button(action: {
                        // TODO: Setting API
                        
                        withAnimation {
                            showSheet = false
                        }
                    }) { // TODO: time setting
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.key)
                                .frame(height: 40)
                                .padding(.horizontal, 12)
                            
                            Text("설정하기")
                                .textStyle(.login_info)
                                .foregroundStyle(.black000)
                        }
                    }
                    .padding(.bottom, 100) // 탭바에 가려지지 않게 80 추가
                    .buttonStyle(.plain)
                    
                }
                .padding(.top, 17)
                .padding(.horizontal, 15)
                
            }
            .frame(height: 404) // 탭바에 가려지지 않게 80 추가
            
        }
        .padding(.horizontal, 18)
        .ignoresSafeArea()
        .task {
            switch timeType {
            case .first:
                selectedHour = viewModel.data.dailyReminderHour
                selectedMinute = viewModel.data.dailyReminderMinute
            case .second:
                selectedHour = viewModel.data.unansweredReminderHour
                selectedMinute = viewModel.data.unansweredReminderMinute
            }
        }
    }
    
    // 상단바
    private var TopGroup: some View {
        ZStack() {
            Text("시간 설정")
                .textStyle(.Button)
                .foregroundStyle(.white)
            
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showSheet = false
                    }
                }) {
                    Image(.iconClose)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray200)
                }
            }
        }
    }
    
    // 시간
    private var TimePickerGroup: some View {
        HStack {
            // 시간
            Picker("", selection: $selectedHour) {
                ForEach(hours, id: \.self) { hour in
                    Text(String(format: "%02d", hour))
                        .textStyle(.Title_Text_Ko)
                        .foregroundStyle(.gray100)
                }
            }
            .frame(width: 80, height: 140)
            .compositingGroup()
            .pickerStyle(.wheel)
            
            Text(":")
                .textStyle(.Title_Text_Ko)
                .foregroundStyle(.gray100)
            
            // 분
            Picker("", selection: $selectedMinute) {
                ForEach(minutes, id: \.self) { minute in
                    Text(String(format: "%02d", minute))
                        .textStyle(.Title_Text_Ko)
                        .foregroundStyle(.gray100)
                }
            }
            .frame(width: 80, height: 140)
            .compositingGroup()
            .pickerStyle(.wheel)
        }
    }
}

#Preview {
    TimePickerSheet(showSheet: .constant(true), timeType: .first)
        .environmentObject(NotificationSettingViewModel())
}
