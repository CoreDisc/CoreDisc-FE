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
    
    private let notificationProvider = APIManager.shared.createProvider(for: NotificationRouter.self)
    
    // MARK: - Functions
    func fetchNotifications(
        cursorId: Int? = nil,
        size: Int? = 10
    ) {
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
                            self.notificationList.append(contentsOf: result.values)
                        }
                        self.notificationHasNextPage = result.hasNext
                        self.groupNotificationsByDate()
                    }
                } catch {
                    print("GetNotifications 디코더 오류: \(error)")
                }
            case .failure(let error):
                print("GetNotifications API 오류: \(error)")
            }
        }
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
}
