//
//  PostpostsViewModel.swift
//  CoreDisc
//
//  Created by 신연주 on 8/15/25.
//

import Foundation
import SwiftUI
import Moya

class PostWriteViewModel: ObservableObject {
    private let postProvider = APIManager.shared.createProvider(for: PostRouter.self)
    
    @Published var postId: Int = 0
    
    @Published var tempIdList: [Int]? = nil
    @Published var tempPostAnswers: [PostTempIdAnswer] = []
    
    // 게시글 생성 (임시)
    func postPosts(selectedDate: Date, completion: (() -> Void)? = nil) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        let dateString = formatter.string(from: selectedDate)
        
        postProvider.request(.postPosts(selectedDate: dateString)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(PostPostsResponse.self, from: response.data)
                    self.postId = decoded.result.postId
                    
                    completion?()
                    print("POST 성공: postId=\(decoded.result.postId)")
                } catch {
                    print("PostPosts 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("게시글을 생성하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PostPosts API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("게시글을 생성하지 못했습니다.")
                }
            }
        }
    }
    
    // 답변 글 수정 및 작성
    func putTextAnswer(postId: Int, questionOrder: Int, content: String, completion: (() -> Void)? = nil) {
        postProvider.request(.putAnswerText(postId: postId, questionOrder: questionOrder, content: content)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(PutAnswerResponse.self, from: response.data)
                    
                    completion?()
                    print("텍스트 답변 업로드 성공: answerId=\(decoded.result.answerId)")
                } catch {
                    print("PutAnswerText 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("글 답변을 생성하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PutAnswerText API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("글 답변을 생성하지 못했습니다.")
                }
            }
        }
    }
    
    // 답변 이미지 작성/저장
    func putImageAnswer(postId: Int, questionOrder: Int, image: UIImage, completion: (() -> Void)? = nil) {
        guard let data = image.jpegData(compressionQuality: 0.85) else { return }
        postProvider.request(.putAnswerImage(postId: postId, questionOrder: questionOrder, image: data)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(PutAnswerResponse.self, from: response.data)
                    
                    completion?()
                    print("이미지 답변 업로드 성공: answerId=\(decoded.result.answerId)")
                } catch {
                    print("PutAnswerImage 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("이미지 답변을 생성하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PutAnswerImage API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("이미지 답변을 생성하지 못했습니다.")
                }
            }
        }
    }
    
    // 임시저장 게시글 조회
    func getTempPost() {
        postProvider.request(.getTemp) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(PostTempResponse.self, from: response.data)
                    self.tempIdList = decodedData.result?.postIds
                } catch {
                    print("getTemp 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("임시저장 게시글을 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("getTemp API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("임시저장 게시글을 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func getTempId(postId: Int) {
        postProvider.request(.getTempID(postId: postId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(PostTempIdResponse.self, from: response.data)
                    self.tempPostAnswers = decodedData.result.answers
                } catch {
                    print("GetTempId 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("임시저장 게시글을 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetTempId 디코더 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("임시저장 게시글을 불러오지 못했습니다.")
                }
            }
        }
    }
}
