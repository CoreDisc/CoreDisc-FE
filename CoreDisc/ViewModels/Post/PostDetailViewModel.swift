//
//  PostDetailViewModel.swift
//  CoreDisc
//
//  Created by 김미주 on 8/13/25.
//

import Foundation

class PostDetailViewModel: ObservableObject {
    // 게시글 정보
    @Published var memberInfo: PostMainMember = .init(memberId: 0, username: "", profileImg: "")
    @Published var selectedData: String = ""
    @Published var publicity: String = ""
    @Published var answersList: [PostDetailAnswer] = []
    @Published var selectiveDiary: PostSelectiveDiary = .init(who: .UNKNOWN, where: .UNKNOWN, what: .UNKNOWN, mood: "")
    @Published var isLiked: Bool = false
    
    // 댓글
    @Published var commentList: [Comment] = []
    @Published var commentHasNext: Bool = false
    @Published var replyList: [Int: [Comment]] = [:]
    @Published var replyHasNext: [Int: Bool] = [:]
    
    private let provider = APIManager.shared.createProvider(for: PostRouter.self)
    private let commentProvider = APIManager.shared.createProvider(for: CommentRouter.self)
    
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
            return date
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
    
    func fetchCommentList(
        postId: Int,
        cursorId: Int? = nil,
        size: Int? = 20
    ) {
        commentProvider.request(.getComments(
            postId: postId,
            cursorId: cursorId,
            size: size
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(CommentListResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.commentList = result.values
                        } else {
                            // 다음 페이지 -> append
                            self.commentList.append(contentsOf: result.values)
                        }
                        self.commentHasNext = result.hasNext
                    }
                    
                    self.commentList.forEach { comment in
                        self.fetchReplyList(commentId: comment.commentId)
                    }
                } catch {
                    print("GetComments 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("댓글을 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetComments API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("댓글을 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func fetchCommentWrite(
        postId: Int,
        content: String
    ) {
        commentProvider.request(.postComments(
            postId: postId,
            content: content
        )) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try JSONDecoder().decode(CommentWriteResponse.self, from: response.data)
                    self.fetchCommentList(postId: postId)
                } catch {
                    print("PostComments 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("댓글을 작성하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PostComments API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("댓글을 작성하지 못했습니다.")
                }
            }
        }
    }
    
    func fetchReplyList(
        commentId: Int,
        cursorId: Int? = nil,
        size: Int? = 20
    ) {
        commentProvider.request(.getReplies(
            commentId: commentId,
            cursorId: cursorId,
            size: size
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(CommentListResponse.self, from: response.data)
                    let result = decodedData.result
                    
                    DispatchQueue.main.async {
                        if cursorId == nil {
                            // 첫 요청 -> 전체 초기화
                            self.replyList[commentId] = result.values
                        } else {
                            // 다음 페이지 -> append
                            self.replyList[commentId]?.append(contentsOf: result.values)
                        }
                        self.replyHasNext[commentId] = result.hasNext
                    }
                } catch {
                    print("GetReplies 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("덧글을 불러오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("GetReplies API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("덧글을 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func fetchReplyWrite(
        commentId: Int,
        content: String
    ) {
        commentProvider.request(.postReplies(
            commentId: commentId,
            content: content
        )) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try JSONDecoder().decode(CommentWriteResponse.self, from: response.data)
                    self.fetchReplyList(commentId: commentId)
                } catch {
                    print("PostReplies 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("덧글을 작성하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PostReplies API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("덧글을 작성하지 못했습니다.")
                }
            }
        }
    }
    
    // 좋아요
    func fetchLike(postId: Int) {
        provider.request(.postLikes(postId: postId)) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try JSONDecoder().decode(PostLikeResponse.self, from: response.data)
                } catch {
                    print("PostLikes 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("좋아요를 설정하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("PostLikes API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("좋아요를 설정하지 못했습니다.")
                }
            }
        }
    }
    
    func fetchDislike(postId: Int) {
        provider.request(.deleteLikes(postId: postId)) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try JSONDecoder().decode(PostLikeResponse.self, from: response.data)
                } catch {
                    print("DeleteLikes 디코더 오류: \(error)")
                    DispatchQueue.main.async {
                        ToastManager.shared.show("좋아요를 취소하지 못했습니다.")
                    }
                }
            case .failure(let error):
                print("DeleteLikes API 오류: \(error)")
                DispatchQueue.main.async {
                    ToastManager.shared.show("좋아요를 취소하지 못했습니다.")
                }
            }
        }
    }
}
