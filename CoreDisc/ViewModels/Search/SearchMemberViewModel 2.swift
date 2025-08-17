//
//  SearchMemberViewModel.swift
//  CoreDisc
//
//  Created by 이채은 on 8/10/25.
//

import Foundation
import Moya

final class SearchMemberViewModel: ObservableObject {
    @Published var items: [SearchMemberItem] = []
    @Published var hasNext: Bool = false
    @Published var isLoading: Bool = false
    
    private let provider = APIManager.shared.createProvider(for: SearchRouter.self)
    private var pageSize: Int = 10
    
    private var currentKeyword: String = ""
    private var didSendRecordForCurrentQuery: Bool = false
    
    func startSearch(keyword: String, record: Bool = true, size: Int? = nil) {
        currentKeyword = keyword
        items = []
        hasNext = false
        didSendRecordForCurrentQuery = false
        if let size { pageSize = size }
        fetchMore(initialRecordFlag: record)
    }
    
    func fetchMore(initialRecordFlag: Bool? = nil) {
        guard !isLoading else { return }
        isLoading = true
        
        let cursorId = items.last?.id
        let recordParam: Bool? = (cursorId == nil) ? (initialRecordFlag ?? (didSendRecordForCurrentQuery ? nil : true)) : nil
        
        provider.request(
            .searchMembers(keyword: currentKeyword,
                           record: recordParam,
                           cursorId: cursorId,
                           size: pageSize)
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(SearchMembersResponse.self, from: response.data)
                    let r = decoded.result
                    DispatchQueue.main.async {
                        self.items.append(contentsOf: r.values)
                        self.hasNext = r.hasNext
                        self.isLoading = false
                        if recordParam == true {
                            self.didSendRecordForCurrentQuery = true
                        }
                    }
                } catch {
                    DispatchQueue.main.async { self.isLoading = false }
                }
            case .failure:
                DispatchQueue.main.async { self.isLoading = false }
            }
        }
    }
    
    func loadMoreIfNeeded(current item: SearchMemberItem) {
        guard hasNext, !isLoading else { return }
        if items.last?.id == item.id {
            fetchMore()
        }
    }
}
