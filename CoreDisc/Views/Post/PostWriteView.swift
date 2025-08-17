//
//  PostWriteView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/3/25.
//

import SwiftUI
import PhotosUI

struct CardContent {
    var image: UIImage? = nil
    var text: String = ""
    var isTextMode: Bool = false
}

struct PostWriteView: View {
    @StateObject private var viewModel = PostpostsViewModel()
    @State private var selectedDate = Date()
    
    @State private var isCorelist: Bool = false
    
    private let questions = [
        "오늘 아침은 무엇을 먹었나요?",
        "오늘 가장 행복했던 순간은?",
        "오늘 만난 사람은?",
        "오늘의 날씨는 어땠나요?"
    ]
    
    // 현재 슬라이드 인덱스
    @State private var pageIndex: Int = 0
    
    // 모든 페이지에 대한 이미지/텍스트 답변 상태
    @State private var cards: [CardContent] = Array(repeating: CardContent(), count: 4)
    
    // 사진/텍스트 입력 표시 상태
    @State private var showPhotoPicker: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationStack{
            ZStack {
                Image(.imgShortBackground)
                    .resizable()
                    .ignoresSafeArea()
                
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
            }
        }
        .navigationBarBackButtonHidden()
        
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhotoItem, matching: .images)
        .onChange(of: selectedPhotoItem) { newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    cards[pageIndex].image = uiImage
                    cards[pageIndex].isTextMode = false
                }
                selectedPhotoItem = nil
            }
        }
    }
    
    
    // 사용자 정보 및 저장버튼 섹션
    private var UserGroup: some View {
        VStack (alignment: .center){
            
            // 개인정보, 저장버튼
            HStack {
                Circle() // TODO: 추후 프로필 사진으로 변경
                    .frame(width: 32, height: 32)
                
                Spacer().frame(width: 11)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("@music_sama")
                        .textStyle(.Pick_Q_Eng)
                        .foregroundStyle(.gray100)
                    
                    Text("2025-07-07")
                        .textStyle(.Button_s)
                        .foregroundStyle(.gray100)
                }
                
                Spacer()
                
                // 저장버튼
                Button(action: {
                    // TODO: 추가 예정
                }){
                    Text("저장")
                        .textStyle(.Q_Main)
                        .foregroundStyle(.highlight)
                        .underline()
                }
                
                Spacer().frame(width: 8)
                
                // 임시저장버튼
                Button(action: {
                    // TODO: 추가 예정
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
                //.padding(.horizontal, 47)
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
                .cornerRadius(12)
        }
    }
    
    
    // 하단섹션
    private var BottomGroup: some View {
        let toggleWidth: CGFloat = 123
        let toggleHeight: CGFloat = 50
        let nextDiameter: CGFloat = 50
        let spacing: CGFloat = 16
        let offsetX: CGFloat = (toggleWidth / 2) + spacing + (nextDiameter / 2)
        
        let answeredCount = cards.filter { isAnswered($0) }.count
        let canGoNext = (answeredCount == cards.count)
        
        return ZStack {
            // 공개범위 버튼
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCorelist.toggle()
                }
            }) {
                ZStack(alignment: isCorelist ? .trailing : .leading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.gray800)
                        .frame(width: 42, height: 42)
                    
                    RoundedRectangle(cornerRadius: 30)
                        .fill(isCorelist ? .gray600 : .black000)
                        .frame(width: toggleWidth, height: toggleHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.gray400, lineWidth: 2)
                        )
                        .padding(.horizontal, 2)
                    
                    HStack(spacing: 17) {
                        if isCorelist {
                            // Circle 상태 (오른쪽)
                            Text("Circle")
                                .textStyle(.login_info)
                                .foregroundColor(.white)
                            ZStack {
                                Circle()
                                    .fill(.key)
                                    .frame(width: 42, height: 42)
                                
                                Image(.iconCore)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 23, height: 16)
                                    .foregroundStyle(.gray600)
                            }
                            .padding(.vertical, 6)
                            .padding(.trailing, -16)
                            
                        } else {
                            // Public 상태 (왼쪽)
                            ZStack {
                                Circle()
                                    .fill(.gray100)
                                    .frame(width: 42, height: 42)
                                
                                Image(systemName: "globe")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height:20)
                                    .foregroundStyle(.black000)
                            }
                            .padding(.vertical, 6)
                            .padding(.leading, -16)
                            
                            Text("Public")
                                .textStyle(.login_info)
                                .foregroundColor(.white)
                        }
                        
                    }
                    .frame(width: toggleWidth, height: toggleHeight)
                }
                .buttonStyle(.plain)
            }
            
            // 넘어가기 버튼
            NavigationLink(destination: PostWriteDiaryView()) {
                ZStack {
                    Circle()
                        .frame(width: nextDiameter, height: nextDiameter)
                        .foregroundStyle(canGoNext ? .key : .gray200)
                    Image(.iconArrow)
                }
            }
            .offset(x: offsetX)
            .disabled(!canGoNext) // 답변 미 작성시 버튼 막기
            .simultaneousGesture(TapGesture().onEnded {
                viewModel.postPosts(selectedDate: ymd(selectedDate))
            })
        }
        .frame(maxWidth: .infinity, minHeight: 50)
    }
    
    
    // 슬라이딩 시 질문 변경
    private var currentQuestion: String {
        (0..<questions.count).contains(pageIndex) ? questions[pageIndex] : (questions.first ?? "")
    }
    
    
    // 게시글 작성 답변 카드
    private struct CardPageView: View {
        @Binding var card: CardContent
        let onTapPhoto: () -> Void
        let onTapWrite: () -> Void
        
        
        // 글/그림 선택 버튼 항상 표시
        private var showButtons: Bool {
            true }
        
        var body: some View {
            ZStack {
                // 배경 카드
                Rectangle()
                    .fill(Color.gray400)
                    .frame(width: 308, height: 409)
                    .cornerRadius(20.83)
                
                // 사진 표시
                if let image = card.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 308, height: 409)
                        .clipped()
                        .cornerRadius(20.83)
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
    
    private func ymd(_ date: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
    
    // 카드 답변 여부 확인 함수
    private func isAnswered(_ c: CardContent) -> Bool {
        if c.image != nil { return true }
        return !c.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}


#Preview {
    PostWriteView()
}
