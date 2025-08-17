//
//  NotificationViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 8/7/25.
//

import Foundation

class NotificationViewModel: ObservableObject {
    // MARK: - Properties
    // fetchNotifications
    @Published var notificationList: [NotificationValues] = []
    @Published var groupedNotifications: [(date: String, values: [NotificationValues])] = []
    @Published var notificationHasNextPage: Bool = false
    @Published var isLoading: Bool = false
    
    var unreadResult: Bool = false
    
    private let notificationProvider = APIManager.shared.createProvider(for: NotificationRouter.self)
    
    // MARK: - Functions
    // 첫 페이지 & 새로고침
    func refresh(size: Int? = 10) {
        fetchNotifications(cursorId: nil, size: size)
    }
    
    // 날짜별로 묶기
    private func groupNotificationsByDate() {
        let groupedDict = Dictionary(grouping: notificationList) { item in
            String(item.createdAt.prefix(10)) // yyyy-MM-dd
        }

        self.groupedNotifications = groupedDict
            .sorted { $0.key > $1.key } // 최신순 정렬
            .map { ($0.key, $0.value) }
    }
    
    // 마지막 셀 -> 호출
    func loadNextPageIfNeeded(currentItem: NotificationValues) {
        guard notificationHasNextPage, !isLoading else { return }
        if let last = notificationList.last, last.notificationId == currentItem.notificationId {
            let cursor = last.notificationId
            fetchNotifications(cursorId: cursor, size: 10)
        }
    }
    
    // MARK: - API
    func fetchNotifications(
        cursorId: Int? = nil,
        size: Int? = 10
    ) {
        if isLoading { return }
        isLoading = true
        
        notificationProvider.request(.getNotification(cursorId: cursorId, size: size)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(NotificationResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.notificationList = result.values
                        } else {
                            // 다음 페이지 -> append
                            let existingIds = Set(self.notificationList.map { $0.notificationId })
                            let newOnes = result.values.filter { !existingIds.contains($0.notificationId) }
                            self.notificationList.append(contentsOf: newOnes)
                        }
                        self.notificationHasNextPage = result.hasNext
                        self.groupNotificationsByDate()
                        self.isLoading = false
                    }
                } catch {
                    print("GetNotifications 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("알림 리스트를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetNotifications API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("알림 리스트를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func fetchRead(notificationId: Int) {
        notificationProvider.request(.patchNotificationRead(notificationId: notificationId)) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try JSONDecoder().decode(NotificationReadResponse.self, from: response.data)
                    // 현재 페이지 상태 유지
                    if (self.notificationList.first?.notificationId) != nil {
                        self.fetchNotifications(cursorId: nil, size: self.notificationList.count)
                    } else {
                        self.fetchNotifications(cursorId: nil, size: 10)
                    }
                } catch {
                    print("PatchNotificationRead 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("알림 조회 상태를 변경하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PatchNotificationRead API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("알림 조회 상태를 변경하지 못했습니다.")
                }
            }
        }
    }
    
    func fetchUnRead() {
        notificationProvider.request(.getNotificationUnread) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(NotificationUnreadResponse.self, from: response.data)
                    self.unreadResult = decodedData.result
                } catch {
                    print("GetNotificationUnread 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("알림 존재 여부를 확인하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetNotificationUnread API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("알림 존재 여부를 확인하지 못했습니다.")
                }
            }
        }
    }
}
