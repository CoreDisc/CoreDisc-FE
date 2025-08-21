//
//  QuestionMainView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct QuestionMainView: View {
    @Environment(NavigationRouter<QuestionRoute>.self) private var router
    
    @StateObject var viewModel = QuestionMainViewModel()
    
    @State var isSelectView: Bool = false
    @State var currentOrder: Int = 0
    @State var currentQuestionType: String = ""
    
    // 씨디 돌아가는 애니메이션
    @State private var rotationAngle: Double = 0.0
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    @State var showModal: Bool = false
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                TitleGroup
                
                Spacer().frame(height: 36)
                
                MainCDGroup
                
                Spacer()
            }
            
            if showModal {
                BackModalView(showModal: $showModal, content: "오늘은 모든 질문을 설정했어요.\n하루질문은 내일 다시 선택할 수 있어요.", buttonTitle: "확인")
            }
        }
        .task {
            viewModel.fetchSelected()
        }
    }
    
    // 상단 타이틀
    private var TitleGroup: some View {
        VStack(alignment: .leading, spacing: 1) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.4)) {
                    isSelectView = false
                }
            }) {
                Image(.iconBack)
            }
            .buttonStyle(.plain)
            .opacity(isSelectView ? 1 : 0) // select일 때만 보이게
            
            Text(isSelectView ? "Select your own disc" : "Today’s Coredisc")
                .textStyle(.Title_Text_Eng)
                .foregroundStyle(.key)
                .padding(.leading, 6)
                .padding(.bottom, 5)
            
            Text(isSelectView ? "\(currentQuestionType == "FIXED" ? "한 달동안" : "오늘") 함께 할 질문을 선택하세요" : "오늘의 코어디스크를 기록해보세요")
                .textStyle(.Sub_Text_Ko)
                .foregroundStyle(.white)
                .padding(.leading, 11)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 17)
    }
    
    // CD, QuestionSelectItem
    // TODO: CD 애니메이션 적용
    private var MainCDGroup: some View {
        // 색상 설정
        func colors(for type: String?) -> (Color, Color) {
            switch type {
            case "FIXED":
                return (.key, .gray600)
            case "RANDOM":
                return (.warning, .gray100)
            default:
                return (.gray400, .gray400)
            }
        }
        
        // 질문 리스트
        let question1 = viewModel.selectedQuestions.first(where: { $0.questionOrder == 1 })
        let question2 = viewModel.selectedQuestions.first(where: { $0.questionOrder == 2 })
        let question3 = viewModel.selectedQuestions.first(where: { $0.questionOrder == 3 })
        let question4 = viewModel.selectedQuestions.first(where: { $0.questionOrder == 4 })
        
        return GeometryReader { g in
            ZStack {
                Image(.imgCd)
                    .resizable()
                    .frame(width: 529, height: 529)
                    .rotationEffect(.degrees(-rotationAngle))
                    .onReceive(timer) { _ in
                        withAnimation {
                            rotationAngle += 1 // 회전 속도 조절
                        }
                    }
                    .offset(x: 172)
                
                QuestionSelectItem(
                    viewModel: viewModel,
                    showModal: $showModal,
                    moveLeft: $isSelectView,
                    currentQuestionType: $currentQuestionType,
                    text: question1?.question ?? "한달질문을 선택하세요",
                    order: 1,
                    onTap: { currentOrder = $0 },
                    startColor: colors(for: question1?.questionType).0,
                    endColor: colors(for: question1?.questionType).1
                )
                .position(x: 150+79, y: 97)
                
                QuestionSelectItem(
                    viewModel: viewModel,
                    showModal: $showModal,
                    moveLeft: $isSelectView,
                    currentQuestionType: $currentQuestionType,
                    text: question2?.question ?? "한달질문을 선택하세요",
                    order: 2,
                    onTap: { currentOrder = $0 },
                    startColor: colors(for: question2?.questionType).0,
                    endColor: colors(for: question2?.questionType).1
                )
                .position(x: 150+34, y: 196)
                
                QuestionSelectItem(
                    viewModel: viewModel,
                    showModal: $showModal,
                    moveLeft: $isSelectView,
                    currentQuestionType: $currentQuestionType,
                    text: question3?.question ?? "한달질문을 선택하세요",
                    order: 3,
                    onTap: { currentOrder = $0 },
                    startColor: colors(for: question3?.questionType).0,
                    endColor: colors(for: question3?.questionType).1
                )
                .position(x: 150+42, y: 295)
                
                QuestionSelectItem(
                    viewModel: viewModel,
                    showModal: $showModal,
                    moveLeft: $isSelectView,
                    currentQuestionType: $currentQuestionType,
                    text: question4?.question ?? "하루질문을 선택하세요",
                    order: 4,
                    onTap: { currentOrder = $0 },
                    startColor: colors(for: question4?.questionType).0,
                    endColor: colors(for: question4?.questionType).1
                )
                .position(x: 150+79, y: 394)
                
                SelectCDGroup
                    .offset(x: 460)
            }
            .frame(width: g.size.width, height: 529)
            .offset(x: isSelectView ? -366 : 0)
        }
    }
    
    private var SelectCDGroup: some View {
        VStack(spacing: 22) {
            QuestionSelectButton(title: "질문 작성", destination: .write)
            QuestionSelectButton(title: "기본 질문", destination: .basic(selectedQuestionType: currentQuestionType, order: currentOrder))
            QuestionSelectButton(title: "인기 질문", destination: .trending(selectedQuestionType: currentQuestionType, order: currentOrder))
            QuestionSelectButton(title: "공유/저장\n질문", destination: .shareNow(selectedQuestionType: currentQuestionType, order: currentOrder))
        }
        .offset(x: 0)
    }
}

// 질문 선택 컴포넌트
struct QuestionSelectItem: View {
    @ObservedObject var viewModel: QuestionMainViewModel
    
    @Binding var showModal: Bool
    @Binding var moveLeft: Bool
    @Binding var currentQuestionType: String
    
    var text: String
    var order: Int // 1, 2, 3
    var onTap: ((Int) -> Void)? = nil
    
    var startColor: Color
    var endColor: Color
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.4)) {
                if order == 4 {
                    currentQuestionType = "RANDOM"
                } else {
                    currentQuestionType = "FIXED"
                }
                moveLeft = true
                onTap?(order)
                
                if viewModel.selectedQuestions.allSatisfy({ $0.id != nil }) {
                    showModal = true
                }
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white.gradient.shadow(.inner(color: .shadow, radius: 2, y: -2))) // 내부 그림자
                    .frame(width: 210, height: 48)
                
                HStack(spacing: 8) {
                    Circle()
                        .horizontalLinearGradient(startColor: startColor, endColor: endColor)
                        .frame(width: 27)
                    
                    Text(text)
                        .textStyle(.Q_pick)
                        .foregroundStyle(.black000)
                        .frame(width: 143, alignment: .leading)
                        .lineLimit(1)
                }
            }
        }
    }
}

// 질문 선택 버튼 컴포넌트
struct QuestionSelectButton: View {
    @Environment(NavigationRouter<QuestionRoute>.self) private var router
    
    var title: String
    var destination: QuestionRoute
    
    var body: some View {
        Button(action: {
            router.push(destination)
        }) {
            buttonContent
        }
    }
    
    private var buttonContent: some View {
        ZStack(alignment: .top) {
            Image(.imgCd)
                .resizable()
                .frame(width: 76, height: 76)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 4)
                    .horizontalLinearGradient(startColor: .white, endColor: .gray400)
                    .frame(width: 98, height: 68)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                
                Text(title)
                    .textStyle(.Q_Main)
                    .foregroundStyle(.black000)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 10)
                    .padding(.leading, 9)
            }
            .padding(.top, 38)
        }
        .compositingGroup()
    }
}

#Preview {
    QuestionMainView()
}
