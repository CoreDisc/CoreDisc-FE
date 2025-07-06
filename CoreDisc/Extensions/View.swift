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

extension View {
    func linearGradient(startColor: Color, endColor: Color) -> some View {
        modifier(LinearGradientModifier(startColor: startColor, endColor: endColor))
    }
}
