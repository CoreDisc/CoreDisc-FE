//
//  CommentSheetView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/13/25.
//

import SwiftUI

struct CommentSheetView: View {
    @Binding var showSheet: Bool
    
    // 열려있는 댓글
    @State private var expandedCommentIDs: Set<Int> = []
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            
            VStack {
                Spacer().frame(height: 13)
                
                Capsule()
                    .fill(.gray200)
                    .frame(width: 72, height: 5)
                
                Spacer().frame(height: 30)
                
                List {
                    ForEach(1..<6, id: \.self) { item in
                        VStack(alignment: .leading, spacing: 3) {
                            CommentItem()
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Button(action: {}) {
                                    Text("댓글 달기")
                                        .textStyle(.Small_Text_10)
                                        .foregroundStyle(.gray600)
                                        .padding(.vertical, 6)
                                }
                                .buttonStyle(.plain)
                                
                                Button(action: {
                                    withAnimation {
                                        toggleExpanded(for: item)
                                    }
                                }) {
                                    HStack {
                                        Divider()
                                            .frame(width: 8, height: 0.4)
                                            .background(.gray600)
                                        
                                        Text(expandedCommentIDs.contains(item) ? "댓글 숨기기" : "댓글 더보기 (1)") // TODO: 댓글 개수
                                            .textStyle(.Small_Text_10)
                                            .foregroundStyle(.gray600)
                                            .padding(.vertical, 4)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.leading, 29)
                        }
                        
                        // 댓글 더보기
                        if expandedCommentIDs.contains(item) {
                            CommentItem()
                                .padding(.leading, 29)
                        }
                    }
                    .listRowSeparator(.hidden) // 구분선 제거
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(.plain) // list 주변영역 제거
                .listRowSpacing(15) // 리스트 간격
                .scrollIndicators(.hidden)
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 27)
        .ignoresSafeArea(.all, edges: .bottom)
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
}

struct CommentItem: View {
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 5) {
                Image(.imgShortBackground) // TODO: Profile Image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
                    .clipShape(
                        Circle()
                    )
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 4) {
                        Text("@coredisc.ko")
                            .textStyle(.Comment_ID)
                            .foregroundStyle(.black000)
                        
                        Text("2시간")
                            .textStyle(.Small_Text_10)
                            .foregroundStyle(.gray200)
                    }
                    .padding(.vertical, 1)
                    
                    Text("감정이 흔들렸던 대사나 장면이 기억나시나요?감정이 흔들렸던 대사나 장면이 기억나시나요?감정이 흔들렸던 대사나 장면이 기억나시나요?감정이 흔들렸던 대사나 장면이 기억나시나요?"
                        .splitCharacter())
                    .textStyle(.Small_Text_12)
                }
            }
        }
    }
}

#Preview {
    CommentSheetView(showSheet: .constant(true))
}
