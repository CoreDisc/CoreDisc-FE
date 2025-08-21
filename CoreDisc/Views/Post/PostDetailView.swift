//
//  PostDetailView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/3/25.
//

import SwiftUI
import Kingfisher

struct PostDetailView: View {
    @Environment(NavigationRouter<PostRoute>.self) private var router
    @Environment(NavigationRouter<MyhomeRoute>.self) private var homeRouter
    @StateObject private var viewModel = PostDetailViewModel()
    
    @State var showCommentSheet: Bool = false
    @State private var currentQuestion: String = ""
    
    @State var showUserHome: Bool = false
    @State var isOwner: Bool = false
    @State var commentUsername: String = ""
    
    @State var showDeleteModal: Bool = false
    
    let hosting: HostingStackType
    let postId: Int
    
    var body: some View {
        ZStack {
            Image(.imgPostDetailBg)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                BackButtonGroup
                
                ScrollView {
                    Spacer().frame(height: 40)
                    
                    CardStack(viewModel: viewModel, currentQuestion: $currentQuestion)
                    
                    Spacer().frame(height: 8)
                    
                    AnswerGroup
                    
                    Spacer().frame(height: 20)
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color.highlight)
                        .padding(.horizontal, 30)
                    
                    Spacer().frame(height: 20)
                    
                    VStack(spacing: 27) {
                        TodaysDiscGroup
                        
                        Divider()
                            .frame(height: 1)
                            .background(Color.highlight)
                            .padding(.horizontal, 30)
                        
                        ReportSlideGroup
                        
                        SelectiveDiary(viewModel: viewModel)
                    }
                    .padding(.bottom, 70)
                }
            }
            
            // 게시글 삭제 모달
            if showDeleteModal {
                ModalView {
                    VStack(spacing: 10) {
                        Text("게시글은 삭제 후 복구할 수 없습니다.")
                            .textStyle(.Button_s)
                        
                        Text("삭제하시겠습니까?")
                            .textStyle(.Button_s)
                    }
                } leftButton: {
                    Button(action: {
                        showDeleteModal.toggle()
                    }) {
                        Text("취소하기")
                    }
                } rightButton: {
                    Button(action: {
                        viewModel.fetchDeletePost(postId: postId)
                        showDeleteModal.toggle()
                    }) {
                        Text("삭제하기")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden() // 기본 뒤로가기 버튼 제거
        .sheet(isPresented: $showCommentSheet) {
            CommentSheetView(
                showSheet: $showCommentSheet,
                postId: postId,
                viewModel: viewModel,
                showUserHome: $showUserHome,
                isOwner: $isOwner,
                commentUsername: $commentUsername
            )
                .presentationBackground(.clear)
                .presentationDetents([.height(600)])
                .presentationDragIndicator(.hidden)
        }
        .task {
            viewModel.fetchPostDetail(postId: postId)
        }
        .task(id: viewModel.answersList.count) {
            currentQuestion = viewModel.cardItems.first?.question ?? ""
        }
        .onChange(of: showUserHome) {
            if showUserHome {
                if isOwner {
                    router.push(.myHome)
                } else {
                    router.push(.user(userName: commentUsername))
                }
                showUserHome = false
            }
        }
        .onChange(of: viewModel.isDelete) {
            switch hosting {
            case .post:
                router.pop()
            case .myhome:
                homeRouter.pop()
            case .write, .report, .question:
                return
            }
        }
    }
    
    // 뒤로가기 버튼 섹션
    private var BackButtonGroup: some View {
        HStack{
            Button(action: {
                switch hosting {
                case .post:
                    router.pop()
                case .myhome:
                    homeRouter.pop()
                case .write, .report, .question:
                    return
                }
            }){
                Image(.iconBack)
                    .resizable()
                    .frame(width: 42, height: 42)
            }
            
            Spacer()
            
            if viewModel.isOwner {
                Button(action: {
                    showDeleteModal = true
                }) {
                    Image(.iconDelete)
                        .foregroundStyle(.gray800)
                }
            }
        }
        .padding(.horizontal, 17)
    }
    
    // 답변 섹션
    private var AnswerGroup: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                Text(currentQuestion.splitCharacter())
                    .textStyle(.Q_Main)
                    .foregroundStyle(.black000)
                    .padding(.vertical, 6)
                    .padding(.trailing, 5)
                
                Spacer()
                
                Button(action: {
                    if viewModel.isLiked {
                        viewModel.fetchDislike(postId: postId)
                    } else {
                        viewModel.fetchLike(postId: postId)
                    }
                    viewModel.isLiked.toggle()
                }){
                    Image(viewModel.isLiked ? .iconLoveFill : .iconLove)
                        .resizable()
                        .frame(width: 25.08, height: 25.08)
                        .foregroundStyle(.gray800)
                        .padding(.top,5.46)
                }
                
                Button(action: {
                    showCommentSheet = true
                    viewModel.fetchCommentList(postId: postId)
                }){
                    Image(.iconMessage)
                        .resizable()
                        .frame(width: 25.08, height: 25.08)
                        .foregroundStyle(.gray800)
                        .padding(.top,5.46)
                }
            }
            
            Button(action: {
                if viewModel.isOwner {
                    router.push(.myHome)
                } else {
                    router.push(.user(userName: viewModel.memberInfo.username))
                }
            }) {
                HStack(spacing: 4) {
                    // 프로필 이미지
                    if let url = URL(string: viewModel.memberInfo.profileImg) {
                        KFImage(url)
                            .placeholder({
                                ProgressView()
                                    .controlSize(.mini)
                            })
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                    }
                    
                    // 유저 아이디
                    Text("@\(viewModel.memberInfo.username)")
                        .textStyle(.Post_Id)
                        .foregroundStyle(.gray800)
                }
            }
        }
        .padding(.horizontal, 43)
    }
    
    // Today's Disc 섹션
    private var TodaysDiscGroup: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("Today’s disc")
                .textStyle(.Post_Title)
                .foregroundStyle(.black000)
                .frame(width: 120, height: 43)
            
            VStack(alignment: .leading, spacing: 19) {
                ForEach(viewModel.answersList, id: \.answerId) { answer in
                    QuestionText(question: answer.questionContent.splitCharacter())
                }
            }
        }
        .padding(.horizontal, 22)
        
    }
    
    
    // 선택형 일기 슬라이드 버튼 섹션
    private var ReportSlideGroup: some View {
        HStack(alignment: .center, spacing: 6){
            ForEach(0...3, id: \.self) { index in
                Button(action: {
                }) {
                    Image(.iconPostSlide)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
        }
    }
}

// MARK: - Components
// 사용자 4가지 질문 컴포넌트
struct QuestionText: View {
    var question: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .foregroundStyle(.white)
                .frame(width: 300, height:48)
            
            Text("\(question)")
                .textStyle(.Q_Sub)
                .foregroundStyle(.black000)
                .lineLimit(2)
                .multilineTextAlignment(.center) // 글자 중앙 정렬
                .frame(width: 262)
                .padding(10)
        }
    }
}

// 선택형 일기
struct SelectiveDiary: View {
    @ObservedObject var viewModel: PostDetailViewModel
    @State private var index: Int = 0
    
    private var sets: [(title: String, value: String)] {
        var s: [(String, String)] = [
            ("Who ?", viewModel.whoText),
            ("Where ?", viewModel.whereText),
            ("What ?", viewModel.whatText)
        ]
        if !viewModel.moodText.isEmpty {
            s.append(("More ?", viewModel.moodText))
        }
        return s
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.key)
                .frame(width: 344, height:514)
            
            VStack(spacing: 0) {
                Spacer().frame(height: 23)
                
                Text("coredisc")
                    .textStyle(.Post_Sub)
                    .foregroundStyle(.white)
                
                Spacer().frame(height: 5)
                
                Text(viewModel.memberInfo.username)
                    .textStyle(.Title_Text_Ko)
                    .foregroundStyle(.black000)
                
                Spacer().frame(height: 19)
                
                ZStack {
                    Circle()
                        .frame(width: 270,height: 270)
                        .foregroundStyle(.white)
                    
                    VStack {
                        Text(sets[index].title)
                            .textStyle(.Pick_Q_Eng)
                            .foregroundStyle(.black000)
                        
                        Spacer().frame(height: 62)
                        
                        Text(sets[index].value)
                            .textStyle(.A_Main)
                            .foregroundStyle(.black000)
                    }
                    .frame(width: 218, height: 107)
                    .padding(.top, 35)
                    .padding(.bottom,118)
                }
                
                Spacer().frame(height: 19)
                
                HStack (alignment: .center, spacing: 19) {
                    Button(action:{
                        guard !sets.isEmpty else { return }
                        withAnimation {
                            index = (index - 1 + sets.count) % sets.count
                        }
                    }) {
                        Image(.iconPlayBack)
                            .resizable()
                            .frame(width:44, height: 44)
                    }
                    
                    Button(action:{}) {
                        Image(.iconPlay)
                            .resizable()
                            .frame(width:44, height: 44)
                    }
                    
                    Button(action:{
                        guard !sets.isEmpty else { return }
                        withAnimation {
                            index = (index + 1) % sets.count
                        }
                    }) {
                        Image(.iconPlayNext)
                            .resizable()
                            .frame(width:44, height: 44)
                    }
                    
                }
                Spacer().frame(height: 3)
                
                Text(viewModel.getDateString(date: viewModel.selectedData))
                    .textStyle(.Post_Time)
                    .foregroundStyle(.black000)
                    .frame(width:106, height: 42, alignment: .center)
            }
        }
    }
}

//#Preview {
//    PostDetailView(postId: 1)
//}
