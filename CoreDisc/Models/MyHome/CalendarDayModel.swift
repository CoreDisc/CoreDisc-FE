//
//  CalendarDayModel.swift
//  CoreDisc
//
//  Created by 이채은 on 8/9/25.
//

import Foundation

struct CalendarDayModel: Identifiable {
    var id: UUID = .init()
    let day: Int
    let date: Date
    let isCurrentMonth: Bool
}
