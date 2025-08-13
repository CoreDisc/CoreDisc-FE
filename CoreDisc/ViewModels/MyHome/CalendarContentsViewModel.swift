//
//  CalendarContentsViewModel.swift
//  CoreDisc
//
//  Created by 이채은 on 8/9/25.
//

import SwiftUI
import Moya
import Combine
import UIKit

// MARK: - ViewModel

final class CalendarContentsViewModel: ObservableObject {

    // MARK: - Published States
    @Published var currentMonth: Date
    @Published var selectedDate: Date

    @Published var continuesDays: Int = 0           // ✅ 월과 무관하게 이어지는 연속 일수
    @Published var totalDays: Int = 0               // 해당 월의 총 기록 일수
    @Published var hasPrevMonth: Bool = false
    @Published var hasNextMonth: Bool = false
    @Published var selectedPostId: Int? = nil

    /// day 키(yyyy-MM-dd) -> DTO
    @Published private var dtoMap: [String: CalendarDayDTO] = [:]

    // MARK: - Dependencies
    let calendar: Calendar
    private let calendarProvider = APIManager.shared.createProvider(for: CalendarRouter.self)
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Derived
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

        // 초기 로딩
        fetchCalendar(year: currentMonthYear, month: currentMonthNumber)
        fetchContinuousDays()

        // 날짜 변경/앱 포그라운드 복귀 시 연속 일수 갱신 (월과 무관)
        observeDayChange()
        observeAppActive()
    }

    deinit {
        cancellables.removeAll()
    }

    // MARK: - Public API

    /// 월 전환 (연속 일수는 월과 무관하므로 여기서 호출하지 않음)
    func changeMonth(by value: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) else { return }
        currentMonth = newMonth
        fetchCalendar(year: currentMonthYear, month: currentMonthNumber)
        // 필요 시 정책 변경에 따라 아래 주석 해제 가능
        // fetchContinuousDays()
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

    /// 월간 캘린더 조회
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
                        self.dtoMap        = map
                        self.totalDays     = r.totalDays
                        self.hasPrevMonth  = r.hasPrevMonth ?? false
                        self.hasNextMonth  = r.hasNextMonth ?? false
                    }
                } catch {
                    print("Calendar decode error:", error)
                    DispatchQueue.main.async {
                        self.dtoMap = [:]
                        self.totalDays = 0
                        self.hasPrevMonth = false
                        self.hasNextMonth = false
                    }
                }

            case .failure(let err):
                print("Calendar API error:", err)
                DispatchQueue.main.async {
                    self.dtoMap = [:]
                    self.totalDays = 0
                    self.hasPrevMonth = false
                    self.hasNextMonth = false
                }
            }
        }
    }

    /// 연속 일수 조회 (/api/reports/calendar/continuous)
    func fetchContinuousDays() {
        calendarProvider.request(.getContinuousDays) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(ContinuousDaysAPIResponse.self, from: response.data)
                    DispatchQueue.main.async { self.continuesDays = decoded.result }
                } catch {
                    print("ContinuousDays decode error:", error)
                    DispatchQueue.main.async { self.continuesDays = 0 }
                }
            case .failure(let err):
                print("ContinuousDays API error:", err)
                DispatchQueue.main.async { self.continuesDays = 0 }
            }
        }
    }

    // MARK: - Observers (streak은 월과 무관: 날짜 경계/앱 재진입 시 갱신)

    private func observeDayChange() {
        NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
            .sink { [weak self] _ in
                self?.fetchContinuousDays()
            }
            .store(in: &cancellables)
    }

    private func observeAppActive() {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.fetchContinuousDays()
            }
            .store(in: &cancellables)
    }

    // MARK: - Grid (UI 계산용)

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

    private static let keyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.timeZone = .current
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    private func key(for date: Date) -> String {
        Self.keyFormatter.string(from: date)
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
