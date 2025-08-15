//
//  PostCardStackView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/14/25.
//

import SwiftUI
import Kingfisher

enum PostCardType: Equatable {
    case image(String)
    case text(String)
}

struct CardItem: Identifiable, Equatable {
    let id: Int
    let type: PostCardType
    let question: String
}

struct CardStack: View {
    @ObservedObject var viewModel: PostDetailViewModel
    @Binding var currentQuestion: String // 현재 질문 상단뷰로
    
    @State private var topIndex: Int = 0
    
    let baseSize = CGSize(width: 256, height: 340)
    let scaleStep: CGFloat = 0.95
    let yOffsetStep: CGFloat = -20
    
    // 제스처
    @State private var dragOffset: CGSize = .zero
    @State private var isSwipingOut = false
    @State private var swipeDirection: CGFloat = 0 // 왼쪽 -1, 오른쪽 1
    
    private var items: [CardItem] { viewModel.cardItems }
    private var count: Int { items.count }
    
    var body: some View {
        ZStack {
            ForEach(items.indices, id: \.self) { index in
                let depth = depth(of: index)
                
                CardContentView(type: items[index].type, size: baseSize)
                    .frame(width: baseSize.width, height: baseSize.height)
                    .scaleEffect(pow(scaleStep, CGFloat(depth)))
                    .offset(y: CGFloat(depth) * yOffsetStep)
                    .zIndex(Double(items.count - depth))
                    // 최상단에만 모션 적용
                    .modifier(TopCardMotion(
                        isTop: depth == 0,
                        dragOffset: dragOffset,
                        isSwipingOut: isSwipingOut,
                        swipeDirection: swipeDirection,
                        baseSize: baseSize
                    ))
                    .allowsHitTesting(depth == 0)
            }
        }
        .frame(width: baseSize.width, height: baseSize.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    handleDragEnd(value: value)
                }
        )
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: dragOffset)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isSwipingOut)
        .animation(.spring(response: 0.45, dampingFraction: 0.9), value: topIndex)
        .onChange(of: topIndex) {
            currentQuestion = items[topIndex].question
        }
    }
    
    private func depth(of index: Int) -> Int {
        let n = items.count
        return (index - topIndex + n) % n
    }
    
    // 드래그 끝났을 때
    private func handleDragEnd(value: DragGesture.Value) {
        let dx = value.translation.width
        let threshold: CGFloat = 80
        
        // 넘김 확정이라면
        if abs(dx) > threshold {
            swipeDirection = dx > 0 ? 1 : -1
            isSwipingOut = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                topIndex = (topIndex + 1) % items.count
                isSwipingOut = false
                swipeDirection = 0
                dragOffset = .zero
            }
        } else {
            dragOffset = .zero
        }
    }
}

struct CardContentView: View {
    let type: PostCardType
    let size: CGSize
    
    var body: some View {
        ZStack {
            switch type {
            case .image(let url):
                if let url = URL(string: url) {
                    KFImage(url)
                        .placeholder {
                            ProgressView()
                                .controlSize(.mini)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                }
                
            case .text(let content):
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .overlay(
                        Text(content)
                            .textStyle(.Texting_Q)
                            .foregroundStyle(.black000)
                            .multilineTextAlignment(.leading)
                            .padding(25)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    )
                    .frame(width: size.width, height: size.height)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private struct TopCardMotion: ViewModifier {
    let isTop: Bool
    let dragOffset: CGSize
    let isSwipingOut: Bool
    let swipeDirection: CGFloat
    let baseSize: CGSize
    
    func body(content: Content) -> some View {
        guard isTop else { return AnyView(content) }
        
        // 드래그하면 10도 기울어짐
        let angle = Double((dragOffset.width / baseSize.width) * 10)
        // 넘길 땐 25도
        let outAngle = Double(swipeDirection) * 25
        
        return AnyView(
            content
                .offset(x: isSwipingOut ? swipeDirection * (baseSize.width * 1.5) : dragOffset.width,
                        y: isSwipingOut ? -80 : dragOffset.height)
                .rotationEffect(.degrees(isSwipingOut ? outAngle : angle))
        )
    }
}

extension PostDetailViewModel {
    var cardItems: [CardItem] {
        answersList.compactMap { answer in
            switch answer.answerType {
            case "TEXT":
                return CardItem(id: answer.answerId, type: .text(answer.textAnswer?.content ?? ""), question: answer.questionContent)

            case "IMAGE":
                return CardItem(id: answer.answerId, type: .image(answer.imageAnswer?.thumbnailUrl ?? ""), question: answer.questionContent)

            default:
                return nil
            }
        }
    }
}
