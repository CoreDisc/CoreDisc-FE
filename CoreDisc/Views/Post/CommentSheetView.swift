//
//  CommentSheetView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/13/25.
//

import SwiftUI
import Kingfisher

struct CommentSheetView: View {
    @Binding var showSheet: Bool
    let postId: Int
    
    @ObservedObject var viewModel: PostDetailViewModel
    
    // 열려있는 댓글
    @State private var expandedCommentIDs: Set<Int> = []
    
    // 댓글
    @State private var commentText: String = ""
    @FocusState private var isFocused: Bool
    
    @State private var currentCommentId: Int = 0
    @State private var isReply: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                .onTapGesture { // 키보드 내리기 용도
                    isFocused = false
                }
            
            VStack {
                Spacer().frame(height: 13)
                
                Capsule()
                    .fill(.gray200)
                    .frame(width: 72, height: 5)
                
                Spacer().frame(height: 30)
                
                CommentList
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 27)
        .ignoresSafeArea()
        .safeAreaInset(edge: .bottom) {
            TextfieldGroup
                .padding(.horizontal, 27)
        }
    }
    
    private var CommentList: some View {
        List {
            ForEach(viewModel.commentList, id: \.commentId) { item in
                VStack(alignment: .leading, spacing: 3) {
                    CommentItem(item: item)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Button(action: {
                            currentCommentId = item.commentId
                            isReply = true
                            isFocused = true
                        }) {
                            Text("댓글 달기")
                                .textStyle(.Small_Text_10)
                                .foregroundStyle(.gray600)
                                .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                        
                        if item.hasReplies {
                            Button(action: {
                                withAnimation {
                                    toggleExpanded(for: item.commentId)
                                    viewModel.fetchReplyList(commentId: item.commentId)
                                }
                            }) {
                                HStack {
                                    Divider()
                                        .frame(width: 8, height: 0.4)
                                        .background(.gray600)
                                    
                                    Text(expandedCommentIDs.contains(item.commentId) ? "댓글 숨기기" : "댓글 더보기 (\(item.replyCount ?? 0))")
                                        .textStyle(.Small_Text_10)
                                        .foregroundStyle(.gray600)
                                        .padding(.vertical, 4)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.leading, 29)
                }
                
                // 댓글 더보기
                if expandedCommentIDs.contains(item.commentId) {
                    ForEach(viewModel.replyList[item.commentId] ?? [], id: \.commentId) { reply in
                        CommentItem(item: reply)
                            .padding(.leading, 29)
                    }
                }
            }
            .listRowSeparator(.hidden) // 구분선 제거
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .padding(.bottom, 80)
        .listStyle(.plain) // list 주변영역 제거
        .listRowSpacing(15) // 리스트 간격
        .scrollIndicators(.hidden)
        .padding(.horizontal, 20)
    }
    
    private var TextfieldGroup: some View {
        HStack(spacing: 4) {
            TextField("댓글을 달아보세요...", text: $commentText)
                .textStyle(.Texting_Q)
                .foregroundStyle(.black000)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .stroke(.key, lineWidth: 0.5)
                )
                .focused($isFocused)
                .onSubmit {
                    writeComment()
                }
            
            Button(action: {
                writeComment()
            }) {
                Image(.iconCommentUpload)
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 11)
        .background(.white)
    }
    
    // MARK: - function
    // 댓글 열기/닫기 토글
    private func toggleExpanded(for id: Int) {
        if expandedCommentIDs.contains(id) {
            expandedCommentIDs.remove(id)
        } else {
            expandedCommentIDs.insert(id)
        }
    }
    
    private func writeComment() {
        if isReply {
            viewModel.fetchReplyWrite(commentId: currentCommentId, content: commentText)
            commentText = ""
            isReply = false
        } else {
            viewModel.fetchCommentWrite(postId: postId, content: commentText)
            commentText = ""
        }
    }
}

struct CommentItem: View {
    var item: Comment
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 5) {
                if let url = URL(string: item.member.profileImg) {
                    KFImage(url)
                        .placeholder({
                            ProgressView()
                                .controlSize(.mini)
                        })
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                        .clipShape(
                            Circle()
                        )
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 4) {
                        Text("@\(item.member.username)")
                            .textStyle(.Comment_ID)
                            .foregroundStyle(.black000)
                        
                        Text(item.timeStamp ?? "")
                            .textStyle(.Small_Text_10)
                            .foregroundStyle(.gray200)
                    }
                    .padding(.vertical, 1)
                    
                    Text(item.content
                        .splitCharacter())
                    .textStyle(.Small_Text_12)
                }
            }
        }
    }
}
