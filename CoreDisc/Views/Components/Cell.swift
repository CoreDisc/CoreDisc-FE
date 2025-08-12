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
    @Bindable var viewModel: CalendarContentsViewModel
    
    var body: some View {
        let dto = viewModel.dto(for: calendarDay.date)
        let isRecorded = dto?.recorded == true
        let isToday = dto?.today == true
        
        ZStack {
            if !calendarDay.isCurrentMonth {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .frame(width: 44, height: 44)
            } else {
                if isSelected && isRecorded {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.key)
                        .frame(width: 44, height: 44)
                } else if isRecorded && isToday {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray400)
                        .frame(width: 44, height: 44)
                        .border(Color.key, width: 1)
                } else if !isRecorded && isToday {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black)
                        .frame(width: 44, height: 44)
                        .border(Color.key, width: 1)
                } else if isRecorded && !isToday {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.key)
                        .frame(width: 44, height: 44)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black)
                        .frame(width: 44, height: 44)
                }
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
        .frame(height: 44)
        .onTapGesture {
            viewModel.handleTap(on: calendarDay.date)
        }
    }
}
