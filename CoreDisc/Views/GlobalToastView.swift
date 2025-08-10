//
//  GlobalToastView.swift
//  CoreDisc
//
//  Created by 김미주 on 8/10/25.
//

import SwiftUI

struct GlobalToastView: View {
    @ObservedObject private var toastCenter = ToastManager.shared

    var body: some View {
        Color.clear
            .allowsHitTesting(false)
            .modifier(ToastModifier(
                isPresented: Binding(
                    get: { toastCenter.isPresented },
                    set: { if !$0 { toastCenter.hide() } }
                ),
                message: toastCenter.message
            ))
    }
}
