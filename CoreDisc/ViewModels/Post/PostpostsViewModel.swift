//
//  PostpostsViewModel.swift
//  CoreDisc
//
//  Created by 신연주 on 8/15/25.
//

import Foundation
import SwiftUI
import Moya

class PostpostsViewModel: ObservableObject {
    private let postProvider = APIManager.shared.createProvider(for: PostRouter.self)
    
    @Published var postId: Int?
    
    
    // 게시글 생성 (임시)
    func postPosts(selectedDate: String) {
        postProvider.request(.postPosts(selectedDate: selectedDate)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(PostpostsResponse.self, from: response.data)
                    if decoded.isSuccess {
                        self.postId = decoded.result.postId
                        print("POST 성공: postId=\(decoded.result.postId)")
                    } else {
                        print("POST 실패: \(decoded.message)")
                    }
                } catch {
                    print("디코딩 실패:", error)
                }
                
            case .failure(let error):
                print("postPosts Api 연결 오류:", error)
            }
        }
    }
    
    // 답변 글 수정 및 작성
    func putTextAnswer(postId: Int, questionId: Int, content: String) {
        postProvider.request(.putAnswerText(postId: postId, questionId: questionId, content: content)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(PutAnswerResponse.self, from: response.data)
                    if decoded.isSuccess {
                        print("텍스트 답변 업로드 성공: answerId=\(decoded.result.answerId)")
                    } else {
                        print("업로드 실패: [\(decoded.code)] \(decoded.message)")
                    }
                } catch {
                    print("디코딩 실패: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("putTextAnswer 연결 오류: \(error.localizedDescription)")
            }
        }
    }
    
    // 답변 이미지 작성/저장
}
