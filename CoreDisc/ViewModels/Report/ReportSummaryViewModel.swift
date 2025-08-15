//
//  ReportSummaryViewModel.swift
//  CoreDisc
//
//  Created by 정서영 on 7/26/25.
//

import Foundation
import SwiftUI

class ReportSummaryViewModel: ObservableObject {
    
    @Published var summaryTop: [DailyData] = []
    @Published var ExtraDisc: [ExtraDiscModel] = []
    
    private let ReportProvider = APIManager.shared.createProvider(for: ReportRouter.self)
    
    func getSummaryTop(year: Int, month: Int) {
        ReportProvider.request(.getTopSelection(year: year, month: month)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(SummaryTopResponse.self, from: response.data)
                    print("성공: \(decodedResponse)")
                    DispatchQueue.main.async {
                        let monthText = "\(month)월은"
                        let list = decodedResponse.result?.dailyList.map { item -> DailyData in
                            
                            let sentence: String
                            switch item.dailyType {
                            case "누구와 가장 많이 있었을까요?":
                                sentence = "\(monthText) \(item.optionContent)과 가장 많은 시간을 보냈어요."
                            case "어디에 가장 많이 있었을까요?":
                                sentence = "\(monthText) \(item.optionContent)에서 가장 많은 시간을 보냈어요."
                            case "무엇을 가장 많이 했을까요?":
                                sentence = "\(monthText) \(item.optionContent)으로 가장 많은 시간을 보냈어요."
                            default:
                                sentence = "\(monthText) \(item.optionContent)"
                            }
                            return DailyData(
                                dailyType: item.dailyType,
                                optionContent: sentence,
                                selectionCount: item.selectionCount
                            )
                        } ?? []
                        self.summaryTop = list
                    }
                } catch {
                    print("디코딩 실패 : \(error)")
                }
            case .failure(let error):
                print("네트워크 오류 : \(error)")
            }
        }
    }
    
    func getSummaryDetails(year: Int, month: Int) {
        ReportProvider.request(.getDetails(year: year, month: month)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(SummaryDetailsResponse.self, from: response.data)
                    print("성공: \(decodedResponse)")
                    if let dailyDetails = decodedResponse.result?.dailyDetails {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        
                        let outputFormatter = DateFormatter()
                        outputFormatter.dateFormat = "M/d"
                        
                        DispatchQueue.main.async {
                            self.ExtraDisc = dailyDetails.map { (dateString, text) in
                                let dateText: String
                                if let date = formatter.date(from: dateString) {
                                    dateText = outputFormatter.string(from: date)
                                } else {
                                    dateText = dateString // 포맷 실패 시 원문 날짜 사용
                                }
                                return ExtraDiscModel(
                                    text: text.replacingOccurrences(of: "\n", with: " "),
                                    date: dateText
                                )
                            }
                        }
                    }
                } catch {
                    print("디코딩 실패 : \(error)")
                }
            case .failure(let error):
                print("네트워크 오류 : \(error)")
            }
        }
    }
    
//    var ExtraDisc: [ExtraDiscModel] = [
//        .init(text: "7월은 집에서 가장 많은 시간을 보냈네요. 정말 덥고 습하고 절대 밖으로 나가지 않았네요 에어컨이 없으면 살 수가 없을 지경입니다 아이스크림을 하루에 3개씩 먹고 있어요", date: "7/1"),
//        .init(text: "날이 너무 습해서 이불도 눅눅하고 창문 열면 바람도 안 들어오고 선풍기만 돌려대니까 괜히 짜증만 늘어요. 그래서 하루 종일 아무것도 안 하고 가만히 누워만 있었어요", date: "7/2"),
//        .init(text: "7월은 집에서 가장 많은  정말 덥고 습하고 절대 밖으로 나가지 않았네요 에어컨이 없으면 살 수가 없을 지경입니다 아이스크림을 하루에 3개씩 먹고 있어요", date: "7/4"),
//        .init(text: "날이 너무 습해서 이불도 눅눅하고면 바람도 안 들어오고 선풍기만 돌려대니까 괜히 짜증만 늘어요. 그래서 하루 종일 아무것도 안 하고 가만히 누워만 있었어요", date: "7/5"),
//        .init(text: "오늘은 그래도 조금 선선해서 산책을 다녀왔어요. 그래도 아직은 덥긴 덥네요", date: "7/6")
//    ]
}
