//
//  SearchHistoryViewModel.swift
//  CoreDisc
//
//  Created by 이채은 on 8/10/25.
//

import Foundation
import Combine
import Moya

final class SearchHistoryViewModel: ObservableObject {
    @Published var items: [RecentSearchItem] = []
    @Published var hasNext: Bool = false
    @Published var isLoading: Bool = false
    @Published var deletingIds: Set<Int> = []

    private let provider = APIManager.shared.createProvider(for: SearchRouter.self)
    private let pageSize: Int = 10
    
    func refresh() {
        items = []
        hasNext = false
        fetchMore()
    }
    
    func fetchMore() {
        guard !isLoading else { return }
        isLoading = true
        let cursor = items.last?.searchedAt
        provider.request(.getRecent(cursorSearchedAt: cursor, size: pageSize)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(RecentSearchResponse.self, from: response.data)
                    let r = decoded.result
                    DispatchQueue.main.async {
                        self.items.append(contentsOf: r.values)
                        self.hasNext = r.hasNext
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async { self.isLoading = false }
                }
            case .failure:
                DispatchQueue.main.async { self.isLoading = false }
            }
        }
    }
    
    func loadMoreIfNeeded(current item: RecentSearchItem) {
        guard hasNext, !isLoading else { return }
        if items.last?.id == item.id {
            fetchMore()
        }
    }
    
    func deleteHistory(id: Int) {
        guard !deletingIds.contains(id) else { return }
        deletingIds.insert(id)
        provider.request(.deleteHistory(historyId: id)) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.deletingIds.remove(id)
                switch result {
                case .success(let response):
                    if let decoded = try? JSONDecoder().decode(DeleteMessageResponse.self, from: response.data),
                       decoded.isSuccess {
                        self.items.removeAll { $0.id == id }
                    }
                case .failure:
                    break
                }
            }
        }
    }
}
