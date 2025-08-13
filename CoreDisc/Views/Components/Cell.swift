//
//  Cell.swift
//  CoreDisc
//
//  Created by 이채은 on 8/9/25.
//

import SwiftUI

struct Cell: View {
    var calendarDay: CalendarDayModel
    var isSelected: Bool // 현재 스타일엔 영향 없음
    let viewModel: CalendarContentsViewModel

    var body: some View {
        let dto = viewModel.dto(for: calendarDay.date)
        let isRecorded = dto?.recorded == true
        let isToday = dto?.today == true

        ZStack {
            // 배경 사각형
            if !calendarDay.isCurrentMonth {
                // 이번 달이 아니면 검은 배경 + 아이콘
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .frame(width: 44, height: 44)
            } else if !isRecorded && !isToday {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .frame(width: 44, height: 44)
            } else if isRecorded && !isToday {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.key)
                    .frame(width: 44, height: 44)
            } else if !isRecorded && isToday {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .frame(width: 44, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.key, lineWidth: 1)
                    )
            } else { // isRecorded && isToday
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray400)
                    .frame(width: 44, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.key, lineWidth: 1)
                    )
            }

            // 콘텐츠(숫자/아이콘)
            if calendarDay.isCurrentMonth {
                Text("\(calendarDay.day)")
                    .textStyle(.Calendar_text)
                    .foregroundStyle(isRecorded ? .black000 : .gray600)
            } else {
                Image(.iconNodate)
                    .resizable()
                    .frame(width: 31, height: 31)
            }
        }
        .frame(height: 44)
        .onTapGesture { viewModel.handleTap(on: calendarDay.date) }
    }
}
