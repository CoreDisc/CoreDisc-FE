//
//  PostTempView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/20/25.
//

import SwiftUI

struct PostTempView: View {
    @ObservedObject var viewModel: PostWriteViewModel
    @Binding var showModal: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                // 타이틀 + 취소버튼
                HStack {
                    Text("게시글 작성 관련 안내")
                        .textStyle(.Bold_Text)
                        .foregroundStyle(.highlight)
                    
                    Spacer()
                    
                    Button(action: {
                        showModal = false
                    }) {
                        Image(.iconX)
                    }
                }
                
                // 안내 문구
                VStack(alignment: .leading, spacing: 10) {
                    Text("작성한 게시글은 당일 작성, 당일 발행만 가능해요.")
                    Text("게시글 발행을 위해서는 4가지 질문에 답변하고,\n선택형 일기를 작성해야 해요.")
                    Text("모든 조건이 충족되어야 게시글을 등록할 수 있습니다.")
                    Text("임시저장된 게시글은 매일 00시에 자동 삭제됩니다.")
                }
                .textStyle(.Q_Sub)
                .foregroundStyle(.white)
                
                // 게시글 목록
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.tempList ?? [], id: \.postId) { item in
                            addTempList(item: item)
                        }
                    }
                }
                .frame(height: 260)
                .scrollIndicators(.hidden)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 17)
            .padding(.vertical, 25)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray600)
            )
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            viewModel.getTempPost()
        }
    }
    
    private func addTempList(item: PostTempList) -> some View {
        Button(action: {
            viewModel.getTempId(postId: item.postId)
            ToastManager.shared.show("임시저장 게시글을 불러왔습니다.")
            showModal = false
        }) {
            VStack(spacing: 20) {
                Divider()
                    .background(.highlight)
                
                HStack {
                    Text("임시저장된 게시글")
                    
                    Spacer()
                    
                    Text(item.lastModified)
                }
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                
                Divider()
                    .background(.highlight)
            }
        }
    }
}


//#Preview {
//    PostTempView(showModal: .constant(true))
//}
