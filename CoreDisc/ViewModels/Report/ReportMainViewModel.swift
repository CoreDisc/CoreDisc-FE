//
//  DiscItemViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 7/19/25.
//

import Foundation
import Moya

class ReportMainViewModel: ObservableObject {
    
    @Published var DiscList: [DiscItemData] = []
    
    private let DiscProvider = APIManager.shared.createProvider(for: DiscRouter.self)
    
    func getDiscs() {
        DiscProvider.request(.getDiscsList) { result in
            switch result {
            case .success(let response):
                if let decodedResponse = try? JSONDecoder().decode(GetDiscResponse.self, from: response.data) {
                    let discs = decodedResponse.result?.discs.map { raw -> DiscItemData in

                        let monthString = String(format: "%02d", raw.month)
                        let dateLabel = "\(raw.year)-\(monthString)"
                        
                        if raw.hasCoverImage, let url = raw.coverImageUrl {
                            return DiscItemData(
                                id: raw.id,
                                dateLabel: dateLabel,
                                imageUrl: url,
                                localImageName: nil
                            )
                        } else {
                            return DiscItemData(
                                id: raw.id,
                                dateLabel: dateLabel,
                                imageUrl: nil,
                                localImageName: self.imageNameForColor(raw.coverColor)
                            )
                        }
                    } ?? []
                    
                    DispatchQueue.main.async {
                        self.DiscList = discs
                    }
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let decodedResponse = try JSONDecoder().decode(GetDiscResponse.self, from: response.data)
                        print(decodedResponse)
                    } catch {
                        print("디코딩 실패 : \(error.localizedDescription)")
                    }
                } else {
                    print("네트워크 오류: \(error.localizedDescription)")
                }
            }
        }
    }
    private func imageNameForColor(_ color: String) -> String {
        switch color.uppercased() {
        case "WHITE": return "img_gray_cover"
        case "PINK": return "img_pink_cover"
        case "Yellow": return "img_yellow_cover"
        case "Blue": return "img_blue_cover"
        case "PURPLE": return "img_purple_cover"
        case "MINT": return "img_mint_cover"
        case "LAVENDER": return "img_lavender_cover"
        case "RED": return "img_red_cover"
        case "VIOLET": return "img_violet_cover"
        case "ORANGE": return "img_orange_cover"
        default: return "img_pink_cover"
        }
    }
}
