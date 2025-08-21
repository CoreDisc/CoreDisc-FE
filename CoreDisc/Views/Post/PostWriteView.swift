//
//  PostWriteView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/3/25.
//

import SwiftUI
import PhotosUI
import Kingfisher
import Combine

struct CardContent {
    var image: UIImage? = nil
    var imageURL: String? = nil
    var text: String = ""
    var isTextMode: Bool = false
}

struct PostWriteView: View {
    @Environment(NavigationRouter<WriteRoute>.self) private var router
    
    @StateObject private var viewModel = PostWriteViewModel()
    @StateObject private var questionViewModel = QuestionMainViewModel()
    @StateObject private var infoViewModel = MyHomeViewModel()
    
    private var questions: [String] {
        questionViewModel.selectedQuestions.map { $0.question ?? "" }
    }
    
    @State private var selectedDate = Date()
    @State private var isCore: Bool = false
    
    // 현재 슬라이드 인덱스
    @State private var pageIndex: Int = 0
    
    // 모든 페이지에 대한 이미지/텍스트 답변 상태
    @State private var cards: [CardContent] = Array(repeating: CardContent(), count: 4)
    
    // 사진/텍스트 입력 표시 상태
    @State private var showPhotoPicker: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    // 키보드
    @FocusState private var isFocused: Bool
    
    // 모든 답변 입력됐는지 확인
    private var allAnswered: Bool {
        let count = min(cards.count, questions.count)
        return cards.prefix(count).allSatisfy { isAnswered($0) }
    }
    
    // 모달 관리
    @State var showQuestionMoadal: Bool = false
    @State var showOnePostModal: Bool = false
    @State var showAlreadyPostModal: Bool = false
    @State var showTempPostModal: Bool = false
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
                .onTapGesture { // 키보드 내리기 용도
                    isFocused = false
                }
            
            VStack {
                Spacer().frame(height: 22)
                
                UserGroup
                
                Spacer().frame(height: 33)
                
                PostGroup
                
                Spacer().frame(height: 49)
                
                QuestionGroup
                
                Spacer().frame(height: 19)
                
                BottomGroup
                
                Spacer()
            }
            
            // 모달
            if showQuestionMoadal {
                BackModalView(showModal: $showQuestionMoadal, content: "질문 4개를 먼저 선택해 주세요.", buttonTitle: "확인")
            }
            
            if showOnePostModal {
                BackModalView(showModal: $showOnePostModal, content: "하루에 하나의 게시글만 작성할 수 있어요.\n작성한 게시글은 수정이 불가능합니다.", buttonTitle: "확인")
            }
            
            if showAlreadyPostModal {
                BackModalView(showModal: $showAlreadyPostModal, content: "하루에 하나의 게시글만 작성할 수 있어요.\n오늘은 이미 게시글을 작성했어요.", buttonTitle: "뒤로가기")
            }
            
            if showTempPostModal {
                PostTempView(viewModel: viewModel, showModal: $showTempPostModal)
            }
        }
        .navigationBarBackButtonHidden()
        
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhotoItem, matching: .images)
        .task {
            infoViewModel.fetchMyHome()
            questionViewModel.fetchSelected()
            viewModel.postPosts(selectedDate: selectedDate)
        }
        //        .onReceive(viewModel.$tempList) { item in
        //            guard let item = item else { return }
        //
        //            if let firstId = item.first?.postId {
        //                viewModel.postId = firstId
        //                viewModel.getTempId(postId: firstId)
        //            } else {
        //                viewModel.postPosts(selectedDate: selectedDate)
        //            }
        //        }
        .onReceive(viewModel.$tempPostAnswers) { answers in
            applyTempAnswers(answers)
        }
        .onReceive(questionViewModel.$selectedQuestions) { list in
            showQuestionMoadal = list.contains { $0.id == nil }
        }
        .onReceive(viewModel.$isAlreadyPosted
            .compactMap { $0 }
        ) { isPosted in
            if isPosted {
                showAlreadyPostModal = true
                showOnePostModal = false
            } else {
                showOnePostModal = true
                showAlreadyPostModal = false
            }
        }
        .onChange(of: selectedPhotoItem) {
            guard let newItem = selectedPhotoItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    cards[pageIndex].image = uiImage
                    cards[pageIndex].imageURL = nil
                    cards[pageIndex].isTextMode = false
                }
                selectedPhotoItem = nil
            }
        }
    }
    
    
    // 사용자 정보 및 저장버튼 섹션
    private var UserGroup: some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: selectedDate)
        
        return VStack (alignment: .center){
            
            // 개인정보, 저장버튼
            HStack {
                if let url = URL(string: infoViewModel.profileImageURL) {
                    KFImage(url)
                        .placeholder {
                            ProgressView()
                                .controlSize(.mini)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                }
                
                Spacer().frame(width: 11)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("@\(infoViewModel.username)")
                        .textStyle(.Pick_Q_Eng)
                        .foregroundStyle(.gray100)
                    
                    Text(dateString)
                        .textStyle(.Button_s)
                        .foregroundStyle(.gray100)
                }
                
                Spacer()
                
                // 저장버튼
                Button(action: {
                    ToastManager.shared.show("게시글 임시 저장 중 ...")
                    uploadAnswers {
                        ToastManager.shared.show("게시글 임시 저장 완료")
                    }
                }){
                    Text("저장")
                        .textStyle(.Q_Main)
                        .foregroundStyle(.highlight)
                        .underline()
                }
                
                Spacer().frame(width: 8)
                
                // 임시저장버튼
                Button(action: {
                    showTempPostModal = true
                }){
                    Image(.iconSave)
                        .frame(width:42, height: 42)
                    
                }
            }
            .padding(.horizontal,16)
        }
    }
    
    
    // 게시물 작성 섹션
    private var PostGroup: some View {
        VStack (alignment: .center){
            // 게시물 작성란
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(questions.indices, id: \.self) { idx in
                        CardPageView(
                            card: $cards[idx],
                            isFocused: $isFocused,
                            onTapPhoto: {
                                pageIndex = idx
                                showPhotoPicker = true
                            },
                            onTapWrite: {
                                pageIndex = idx
                                cards[idx].isTextMode = true
                                cards[idx].image = nil
                            }
                        )
                        .frame(width: 308, height: 409)
                        .id(idx)
                    }
                }
                .frame(height: 409)
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, 47)
            .scrollTargetBehavior(.paging)
            .scrollPosition(
                id: Binding(
                    get: { Optional(pageIndex) },
                    set: { pageIndex = $0 ?? 0 }
                )
            )
        }
    }
    
    
    // 질문 섹션
    private var QuestionGroup: some View {
        VStack (alignment: .center){
            Text(currentQuestion)
                .textStyle(.Q_Main)
                .foregroundStyle(.highlight)
                .multilineTextAlignment(.center)
                .frame(width: 348, height: 68)
                .background(.black000)
                .clipShape( RoundedRectangle(cornerRadius: 12) )
        }
    }
    
    
    // 하단섹션
    private var BottomGroup: some View {
        ZStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCore.toggle()
                }
            }) {
                ZStack {
                    ZStack(alignment: isCore ? .trailing : .leading) {
                        RoundedRectangle(cornerRadius: 27)
                            .fill(.white)
                            .frame(width: 127, height: 54)
                        
                        RoundedRectangle(cornerRadius: 25)
                            .fill(isCore ? .gray800 : .black000)
                            .frame(width: 123, height: 50)
                            .padding(.horizontal, 2)
                        
                        Image(isCore ? .iconToggleCore : .iconToggleGlobe)
                            .padding(.horizontal, 6)
                    }
                
                    Text(isCore ? "Core" : "Public")
                        .textStyle(.Pick_Q_Eng)
                        .foregroundStyle(.white)
                        .padding(isCore ? .trailing : .leading, 35)
                }
            }
            .buttonStyle(.plain)
            
            if allAnswered {
                Button(action: {
                    ToastManager.shared.show("답변 저장 중 ...")
                    uploadAnswers {
                        ToastManager.shared.show("답변 저장 완료")
                        router.push(.select(postId: viewModel.postId, isCore: isCore))
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(.gray200)
                            .frame(width: 50, height: 50)
                        Image(.iconArrow)
                    }
                }
                .padding(.leading, 210)
            }
        }
        .padding(.bottom, 75)
    }
    
    
    // MARK: - Functions
    // 슬라이딩 시 질문 변경
    private var currentQuestion: String {
        (0..<questions.count).contains(pageIndex) ? questions[pageIndex] : (questions.first ?? "")
    }
    
    // 카드 답변 여부 확인 함수
    private func isAnswered(_ c: CardContent) -> Bool {
        if c.image != nil { return true }
        if c.imageURL != nil { return true }
        return !c.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func uploadAnswers(index: Int = 0, done: @escaping () -> Void) {
        guard !questions.isEmpty else {
            ToastManager.shared.show("게시글 임시 저장 실패: 질문 불러오는 중 ...")
            return
        }
        
        guard viewModel.postId != 0 else {
            ToastManager.shared.show("게시글 임시 저장 실패: 게시글 ID 준비 중 ...")
            return
        }
        
        let count = min(cards.count, questions.count)
        guard index < count else {
            done()
            return
        }
        
        let questionOrder = index + 1
        let card = cards[index]
        
        // 이미지
        if let img = card.image {
            viewModel.putImageAnswer(postId: viewModel.postId, questionOrder: questionOrder, image: img) {
                uploadAnswers(index: index + 1, done: done)
            }
            return
        }
        
        // 텍스트
        if !card.text.isEmpty {
            viewModel.putTextAnswer(postId: viewModel.postId, questionOrder: questionOrder, content: card.text) {
                uploadAnswers(index: index + 1, done: done)
            }
            return
        }
        
        // 임시저장 이미지 그대로 -> 스킵
        if let url = card.imageURL, !url.isEmpty {
            uploadAnswers(index: index + 1, done: done)
            return
        }
        
        // 아무것도 없음 -> 스킵
        uploadAnswers(index: index + 1, done: done)
    }
    
    // 임시저장 게시글 불러오기
    private func applyTempAnswers(_ answers: [PostTempIdAnswer]) {
        for a in answers {
            let idx = a.questionOrder - 1
            guard idx >= 0 && idx < cards.count else { continue }
            guard a.isAnswered else { continue }

            switch a.answerType?.uppercased() {
            case "TEXT":
                if let text = a.textContent {
                    cards[idx].text = text
                    cards[idx].isTextMode = true
                    cards[idx].image = nil
                    cards[idx].imageURL = nil
                }

            case "IMAGE":
                if let urlStr = a.imageUrl {
                    cards[idx].imageURL = urlStr
                    cards[idx].image = nil
                    cards[idx].isTextMode = false
                }

            default:
                if let text = a.textContent, !text.isEmpty {
                    cards[idx].text = text
                    cards[idx].isTextMode = true
                    cards[idx].image = nil
                    cards[idx].imageURL = nil
                } else if let urlStr = a.imageUrl {
                    cards[idx].imageURL = urlStr
                    cards[idx].image = nil
                    cards[idx].isTextMode = false
                }
            }
        }
    }

}

// 게시글 작성 답변 카드
private struct CardPageView: View {
    @Binding var card: CardContent
    @FocusState.Binding var isFocused: Bool
    let onTapPhoto: () -> Void
    let onTapWrite: () -> Void
    
    // 글/그림 선택 버튼 항상 표시
    private var showButtons: Bool {
        true }
    
    var body: some View {
        ZStack {
            // 배경 카드
            RoundedRectangle(cornerRadius: 20.83)
                .fill(Color.gray400)
                .frame(width: 308, height: 409)
            
            // 사진 표시
            if let local = card.image {
                Image(uiImage: local)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 308, height: 409)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20.83))

            } else if let url = URL(string: card.imageURL ?? "") {
                KFImage(url)
                    .placeholder { ProgressView().controlSize(.mini) }
                    .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 308, height: 409)))
                    .cacheOriginalImage()
                    .fade(duration: 0.15)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 308, height: 409)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20.83))
            }
            
            // 텍스트 표시
            if card.isTextMode {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(width: 308 - 24, height: 409 - 24)
                    
                    ZStack (alignment: .top){
                        if card.text.isEmpty {
                            Text("내용을 입력하세요")
                                .foregroundColor(.gray)
                                .padding(.all, 18)
                        }
                        TextEditor(text: $card.text)
                            .focused($isFocused)
                            .multilineTextAlignment(.center)
                            .padding(.all, 10)
                            .foregroundColor(.black)
                            .scrollContentBackground(.hidden)
                            .frame(width: 263)
                            .frame(maxHeight: 356)
                    }
                }
                .padding(.all, 18)
                
                
            } else if !card.text.isEmpty {
                // 텍스트 미리보기
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 308 - 24, height: 409 - 24)
                    .overlay(
                        ScrollView {
                            Text(card.text)
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                        }
                    )
            }
            
            // 사진/글 버튼
            if showButtons {
                VStack (alignment: .leading, spacing: 20) {
                    Button(action: onTapPhoto) {
                        ZStack {
                            Circle().fill(Color.white).frame(width: 60, height: 60)
                            Image(.iconPhoto).renderingMode(.original)
                        }
                    }
                    
                    Button(action: onTapWrite) {
                        ZStack {
                            Circle().fill(Color.white).frame(width: 60, height: 60)
                            Image(.iconWriting).renderingMode(.original)
                        }
                    }
                }
                .padding(.top, 240)
                .padding(.leading, 225)
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    PostWriteView()
        .environment(NavigationRouter<WriteRoute>())
}
