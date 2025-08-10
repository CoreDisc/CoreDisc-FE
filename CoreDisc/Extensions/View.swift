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
                        .background(.gray700.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .shadow(radius: 4)
                        .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 1), value: isPresented)
                .onAppear {
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

extension View {
    func linearGradient(startColor: Color, endColor: Color) -> some View {
        modifier(LinearGradientModifier(startColor: startColor, endColor: endColor))
    }
    
    func horizontalLinearGradient(startColor: Color, endColor: Color) -> some View {
        modifier(HorizontalLinearGradientModifier(startColor: startColor, endColor: endColor))
    }
    
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}
