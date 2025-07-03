//
//  QuestionMainView.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import SwiftUI

struct QuestionMainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("QuestionMainView")
                    .font(.Sub_Text)
                Text("QuestionMainView")
                    .font(.Title_Text)
                
                NavigationLink(destination: QuestionBasicView()) {
                    Text("화면 전환 테스트")
                }
            }
        }
    }
}

#Preview {
    QuestionMainView()
}
