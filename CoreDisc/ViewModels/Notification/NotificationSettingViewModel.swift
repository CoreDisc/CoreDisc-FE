//
//  NotificationSettingViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 8/15/25.
//

import Foundation

enum TimeType {
    case first
    case second
}

class NotificationSettingViewModel: ObservableObject {
    // MARK: - Properties
    @Published var data: NotificationSettingResult = .empty
    
    @Published var firstOn: Bool = false
    @Published var secondOn: Bool = false
    @Published var timeType: TimeType = .first
    
    private let provider = APIManager.shared.createProvider(for: NotificationRouter.self)
    
    var isSecondToggleActive: Bool {
        return firstOn
    }
    var isFirstTimeActive: Bool {
        return firstOn
    }
    var isSecondTimeActive: Bool {
        return firstOn && secondOn
    }
    
    // MARK: - Functions
    func fetchReminderState() {
        provider.request(.getReminder) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(NotificationSettingResponse.self, from: response.data)
                    DispatchQueue.main.async {
                        self.data = decodedData.result
                        self.firstOn  = decodedData.result.dailyReminderEnabled
                        self.secondOn = decodedData.result.unansweredReminderEnabled && self.firstOn
                    }
                } catch {
                    print("GetNotifications 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("알림 상태를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetNotifications API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("알림 상태를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func fetchSetReminder(notificationData: NotificationData) {
        provider.request(.patchReminder(notificationData: notificationData)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(NotificationSettingResponse.self, from: response.data)
                    DispatchQueue.main.async {
                        self.data = decodedData.result
                        self.firstOn  = decodedData.result.dailyReminderEnabled
                        self.secondOn = decodedData.result.unansweredReminderEnabled && self.firstOn
                    }
                } catch {
                    print("GetNotifications 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("알림 상태를 설정하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetNotifications API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("알림 상태를 설정하지 못했습니다.")
                }
            }
        }
    }
}
