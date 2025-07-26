//
//  NotificationViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/21/25.
//

import Foundation

enum TimeType {
    case first
    case second
}

class NotificationViewModel: ObservableObject {
    @Published var timeType: TimeType = .first
    
    @Published var firstHour: Int = 8
    @Published var firstMinute: Int = 0
    
    @Published var secondHour: Int = 8
    @Published var secondMinute: Int = 0
}
