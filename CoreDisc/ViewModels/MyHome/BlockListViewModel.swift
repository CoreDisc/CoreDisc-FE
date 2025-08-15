//
//  BlockListViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 7/21/25.
//

import Foundation

class BlockListViewModel: ObservableObject {
    // MARK: - Properties
    @Published var blockList: [BlockListValue] = []
    @Published var hasNextPage: Bool = false
    
    private let blockProvider = APIManager.shared.createProvider(for: BlockRouter.self)

    // MARK: - Functions - API
    func fetchBlockList(
        cursorId: Int? = nil,
        size: Int? = 10
    ) {
        blockProvider.request(.getBlock(cursorId: cursorId, size: size)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(BlockListResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.blockList = result.values
                        } else {
                            // 다음 페이지 -> append
                            self.blockList.append(contentsOf: result.values)
                        }
                        self.hasNextPage = result.hasNext
                    }
                } catch {
                    print("GetBlocks 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("차단한 사용자 리스트를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetBlocks API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("차단한 사용자 리스트를 불러오지 못했습니다.")
                }
            }
        }
    }
}
