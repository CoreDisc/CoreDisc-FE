//
//  PostDetailViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 8/13/25.
//

import Foundation

class PostDetailViewModel: ObservableObject {
    @Published var memberInfo: PostMainMember = .init(memberId: 0, username: "", profileImg: "")
    @Published var selectedData: String = ""
    @Published var publicity: String = ""
    @Published var answersList: [PostDetailAnswer] = []
    @Published var selectiveDiary: PostSelectiveDiary = .init(who: .UNKNOWN, where: .UNKNOWN, what: .UNKNOWN, mood: "")
    @Published var isLiked: Bool = false
    
    private let provider = APIManager.shared.createProvider(for: PostRouter.self)
    
    var whoText: String { selectiveDiary.who.displayName }
    var whereText: String { selectiveDiary.where.displayName }
    var whatText: String { selectiveDiary.what.displayName }
    var moodText: String { selectiveDiary.mood }
    
    // MARK: - Functions
    func getDateString(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let dateString = dateFormatter.date(from: date) else {
            return ""
        }
        
        dateFormatter.dateFormat = "yy : MM : dd"
        return dateFormatter.string(from: dateString)
    }
    
    // MARK: - API
    func fetchPostDetail(postId: Int) {
        provider.request(.getPostsDetail(postId: postId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(PostDetailResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    self.memberInfo = result.member
                    self.selectedData = result.selectedDate
                    self.publicity = result.publicity
                    self.answersList = result.answers
                    self.selectiveDiary = result.selectiveDiary
                    self.isLiked = result.isLiked
                } catch {
                    print("GetPostsDetail 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("게시글 정보를 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetPostsDetail API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("게시글 정보를 불러오지 못했습니다.")
                }
            }
        }
    }
}
