//
//  CalendarContentsViewModel.swift
//  CoreDisc
//
//  Created by 이채은 on 8/9/25.
//

import SwiftUI
import Moya

@Observable
class CalendarContentsViewModel {
    
    var currentMonth: Date
    var selectedDate: Date
    var calendar: Calendar
    
   
    private let calendarProvider = APIManager.shared.createProvider(for: CalendarRouter.self)
    
    var continuesDays: Int = 0
    var totalDays: Int = 0
    var hasPrevMonth: Bool = false
    var hasNextMonth: Bool = false
    
    var selectedPostId: Int? = nil
    
    private var dtoMap: [String: CalendarDayDTO] = [:]
    
    var currentMonthYear: Int { Calendar.current.component(.year, from: currentMonth) }
    var currentMonthNumber: Int { Calendar.current.component(.month, from: currentMonth) }
    
    init(
        currentMonth: Date = Date(),
        selectedDate: Date = Date(),
        calendar: Calendar = .current
    ) {
        self.currentMonth = currentMonth
        self.selectedDate = selectedDate
        self.calendar = calendar
        fetchCalendar(year: currentMonthYear, month: currentMonthNumber)
    }
    
    func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
            fetchCalendar(year: currentMonthYear, month: currentMonthNumber)
        }
    }
    
    func changeSelectedDate(_ date: Date) {
        if calendar.isDate(selectedDate, inSameDayAs: date) { return }
        selectedDate = date
    }
    
    func handleTap(on date: Date) {
        if let pid = dto(for: date)?.postId {
            selectedPostId = pid
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
                changeSelectedDate(date)
            }
        }
    }
    
    func dto(for date: Date) -> CalendarDayDTO? {
        dtoMap[key(for: date)]
    }
    
    func fetchCalendar(year: Int, month: Int) {
        calendarProvider.request(.getCalendar(year: year, month: month)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(CalendarMonthAPIResponse.self, from: response.data)
                    let r = decoded.result
                    
                    var map: [String: CalendarDayDTO] = [:]
                    for d in r.days {
                        if let k = self.key(year: r.year, month: r.month, day: d.day) {
                            map[k] = d
                        }
                    }
                    DispatchQueue.main.async {
                        self.dtoMap = map
                        self.continuesDays = r.continuesDays
                        self.totalDays = r.totalDays
                        self.hasPrevMonth = r.hasPrevMonth
                        self.hasNextMonth = r.hasNextMonth
                    }
                } catch {
                    print("Calendar decode error: \(error)")
                    DispatchQueue.main.async {
                        self.dtoMap = [:]
                        self.continuesDays = 0
                        self.totalDays = 0
                        self.hasPrevMonth = false
                        self.hasNextMonth = false
                    }
                }
            case .failure(let err):
                print("Calendar API error: \(err)")
                DispatchQueue.main.async {
                    self.dtoMap = [:]
                    self.continuesDays = 0
                    self.totalDays = 0
                    self.hasPrevMonth = false
                    self.hasNextMonth = false
                }
            }
        }
    }
    
    func daysForCurrentGrid() -> [CalendarDayModel] {
        let cal = Calendar.current
        let firstDay = firstDayOfMonth()
        let firstWeekDay = cal.component(.weekday, from: firstDay)
        let daysInMonth = numberOfDays(in: currentMonth)
        
        var days: [CalendarDayModel] = []
        let leadingDays = (firstWeekDay - cal.firstWeekday + 7) % 7
        
        if leadingDays > 0, let previousMonth = cal.date(byAdding: .month, value: -1, to: currentMonth) {
            let daysInPreviousMonth = numberOfDays(in: previousMonth)
            for i in 0..<leadingDays {
                let day = daysInPreviousMonth - leadingDays + 1 + i
                if let date = cal.date(bySetting: .day, value: day, of: previousMonth) {
                    days.append(CalendarDayModel(day: day, date: date, isCurrentMonth: false))
                }
            }
        }
        for day in 1...daysInMonth {
            var components = cal.dateComponents([.year, .month], from: currentMonth)
            components.day = day
            components.hour = 0; components.minute = 0; components.second = 0
            if let date = cal.date(from: components) {
                days.append(CalendarDayModel(day: day, date: date, isCurrentMonth: true))
            }
        }
        let remaining = (7 - days.count % 7) % 7
        if remaining > 0, let nextMonth = cal.date(byAdding: .month, value: 1, to: currentMonth) {
            let daysInNextMonth = numberOfDays(in: nextMonth)
            for day in 1...remaining {
                let validDay = min(day, daysInNextMonth)
                if let date = cal.date(bySetting: .day, value: validDay, of: nextMonth) {
                    days.append(CalendarDayModel(day: validDay, date: date, isCurrentMonth: false))
                }
            }
        }
        return days
    }
    
    func numberOfDays(in date: Date) -> Int {
        Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    func firstDayOfMonth() -> Date {
        let comps = Calendar.current.dateComponents([.year, .month], from: currentMonth)
        return Calendar.current.date(from: comps) ?? Date()
    }
    
    private func key(for date: Date) -> String {
        let f = DateFormatter()
        f.calendar = calendar
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
    
    private func key(year: Int, month: Int, day: Int) -> String? {
        var comp = DateComponents()
        comp.year = year; comp.month = month; comp.day = day
        comp.hour = 0; comp.minute = 0; comp.second = 0
        guard let date = calendar.date(from: comp) else { return nil }
        return key(for: date)
    }
}
