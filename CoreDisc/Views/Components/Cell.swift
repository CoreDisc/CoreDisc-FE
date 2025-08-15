//
//  Cell.swift
//  CoreDisc
//
//  Created by 이채은 on 8/9/25.
//

import SwiftUI

struct Cell: View {
    var calendarDay: CalendarDayModel
    var isSelected: Bool
    let viewModel: CalendarContentsViewModel

    var body: some View {
        let dto = viewModel.dto(for: calendarDay.date)
        let isRecorded = dto?.recorded == true
        let isToday = dto?.today == true

        Group {
            if let postId = dto?.postId {
                NavigationLink(destination: PostDetailView(postId: postId)) {
                    cellBackground(isRecorded: isRecorded, isToday: isToday)
                }
                .buttonStyle(.plain)
            } else {
                cellBackground(isRecorded: isRecorded, isToday: isToday)
                    .onTapGesture { viewModel.handleTap(on: calendarDay.date) }
            }
        }
    }

    private func cellBackground(isRecorded: Bool, isToday: Bool) -> some View {
        ZStack {
            if !calendarDay.isCurrentMonth {
                RoundedRectangle(cornerRadius: 12).fill(Color.black)
            } else if isRecorded && !isToday {
                RoundedRectangle(cornerRadius: 12).fill(Color.key)
            } else if !isRecorded && isToday {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.key, lineWidth: 1))
            } else if isRecorded && isToday {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray400)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.key, lineWidth: 1))
            } else {
                RoundedRectangle(cornerRadius: 12).fill(Color.black)
            }

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
        .frame(width: 44, height: 44)
    }
}

