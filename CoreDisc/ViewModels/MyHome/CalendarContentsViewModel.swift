//
//  CalendarContentsViewModel.swift
//  CoreDisc
//
//  Created by 이채은 on 8/9/25.
//

import SwiftUI
import Moya


class CalendarContentsViewModel: ObservableObject {

    @Published var currentMonth: Date
    @Published var selectedDate: Date
    let calendar: Calendar

    private let calendarProvider = APIManager.shared.createProvider(for: CalendarRouter.self)

    @Published var continuesDays: Int = 0
    @Published var totalDays: Int = 0
    @Published var hasPrevMonth: Bool = false
    @Published var hasNextMonth: Bool = false

    @Published var selectedPostId: Int? = nil
    @Published private var dtoMap: [String: CalendarDayDTO] = [:]

    var currentMonthYear: Int { calendar.component(.year, from: currentMonth) }
    var currentMonthNumber: Int { calendar.component(.month, from: currentMonth) } // 1-based

    // MARK: - Init
    init(
        currentMonth: Date = Date(),
        selectedDate: Date = Date(),
        calendar: Calendar = {
            var c = Calendar(identifier: .gregorian)
            c.timeZone = .current
            c.locale = Locale(identifier: "ko_KR")
            return c
        }()
    ) {
        self.currentMonth = currentMonth
        self.selectedDate = selectedDate
        self.calendar = calendar
        // 현재 month 기준으로 fetch (1-based 그대로)
        fetchCalendar(year: currentMonthYear, month: currentMonthNumber)
    }

    // MARK: - Public API
    func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
            fetchCalendar(year: currentMonthYear, month: currentMonthNumber)
        }
    }

    func handleTap(on date: Date) {
        if let pid = dto(for: date)?.postId {
            selectedPostId = pid
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
                if !calendar.isDate(selectedDate, inSameDayAs: date) {
                    selectedDate = date
                }
            }
        }
    }

    func dto(for date: Date) -> CalendarDayDTO? {
        dtoMap[key(for: date)]
    }

    // MARK: - Networking
    func fetchCalendar(year: Int, month: Int) {
        // print("📤 Requesting calendar:", year, month)
        calendarProvider.request(.getCalendar(year: year, month: month)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(CalendarMonthAPIResponse.self, from: response.data)
                    let r = decoded.result

                    var map: [String: CalendarDayDTO] = [:]
                    for d in r.days {
                        if let k = self.key(year: r.year, month: r.month, day: d.day) { // 1-based 그대로 사용
                            map[k] = d
                        }
                    }

                    DispatchQueue.main.async {
                        self.dtoMap        = map
                        self.totalDays     = r.totalDays
                        self.continuesDays = r.continuesDays ?? 0
                        self.hasPrevMonth  = r.hasPrevMonth ?? false
                        self.hasNextMonth  = r.hasNextMonth ?? false

                        // 디버그: 오늘 DTO 존재 확인
                        // let todayKey = self.key(for: Date())
                        // print("🔎 today dto exists?", map[todayKey] != nil, map[todayKey] as Any)
                    }
                } catch {
                    print("Calendar decode error:", error)
                    DispatchQueue.main.async {
                        self.dtoMap = [:]
                        self.continuesDays = 0
                        self.totalDays = 0
                        self.hasPrevMonth = false
                        self.hasNextMonth = false
                    }
                }

            case .failure(let err):
                print("Calendar API error:", err)
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

    // MARK: - Grid
    func daysForCurrentGrid() -> [CalendarDayModel] {
        let cal = calendar
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
        calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }

    func firstDayOfMonth() -> Date {
        let comps = calendar.dateComponents([.year, .month], from: currentMonth)
        return calendar.date(from: comps) ?? Date()
    }

    // MARK: - Key Helpers
    private func key(for date: Date) -> String {
        let f = DateFormatter()
        f.calendar = calendar
        f.timeZone = calendar.timeZone
        f.locale = calendar.locale
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    private func key(year: Int, month: Int, day: Int) -> String? {
        var comp = DateComponents()
        comp.year = year
        comp.month = month        // 서버 1-based 그대로 사용
        comp.day = day
        comp.hour = 0; comp.minute = 0; comp.second = 0
        guard let date = calendar.date(from: comp) else { return nil }
        return key(for: date)
    }
}
