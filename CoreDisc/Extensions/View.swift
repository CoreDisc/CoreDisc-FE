//
//  View.swift
//  CoreDisc
//
//  Created by 김미주 on 7/4/25.
//

import SwiftUI

// MARK: - 그라데이션

// Linear
struct LinearGradientModifier: ViewModifier {
    var startColor: Color
    var endColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [startColor, endColor]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}

// 가로 Linear
struct HorizontalLinearGradientModifier: ViewModifier {
    var startColor: Color
    var endColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [startColor, endColor]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
}

// MARK: - 특정 모서리 둥글게
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

// MARK: - Toast
struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()

                    Text(message)
                        .textStyle(.Q_Sub)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 30)
                        )
                        .background(.gray700.opacity(0.8))
                        .shadow(radius: 4)
                        .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 1), value: isPresented)
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 탭바 숨기기
final class TabBarVisibility: ObservableObject {
    @Published private(set) var isHidden: Bool = false
    private var hideCount: Int = 0
    
    func pushHidden() {
        hideCount += 1
        isHidden = hideCount > 0
    }
    
    func popHidden() {
        hideCount = max(0, hideCount - 1)
        isHidden = hideCount > 0
    }
    
    func reset() { // 전체 초기화
        hideCount = 0
        isHidden = false
    }
}

struct TabBarHiddenModifier: ViewModifier {
    @EnvironmentObject var tabBarVisibility: TabBarVisibility
    let hidden: Bool

    func body(content: Content) -> some View {
        content
            .onAppear {
                if hidden { tabBarVisibility.pushHidden() }
            }
            .onDisappear {
                if hidden { tabBarVisibility.popHidden() }
            }
    }
}

extension View {
    func linearGradient(startColor: Color, endColor: Color) -> some View {
        modifier(LinearGradientModifier(startColor: startColor, endColor: endColor))
    }
    
    func horizontalLinearGradient(startColor: Color, endColor: Color) -> some View {
        modifier(HorizontalLinearGradientModifier(startColor: startColor, endColor: endColor))
    }
    
    func specificCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message))
    }
    
    func tabBarHidden(_ hidden: Bool) -> some View {
        modifier(TabBarHiddenModifier(hidden: hidden))
    }
}
