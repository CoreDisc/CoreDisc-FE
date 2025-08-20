//
//  WriteTabContainer.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import SwiftUI

struct WriteTabContainer: View {
    var body: some View {
        PostWriteView()
            .navigationDestination(for: WriteRoute.self) { route in
                switch route {
                case .answer:
                    PostWriteView()
                case .select(let postId, let isCore):
                    PostWriteDiaryView(postId: postId, isCore: isCore)
                case .summary(let postId, let selectedWho, let selectedWhere, let selectedWhat, let selectedMore, let selectedMoreString, let isCore):
                    PostDiaryCheckView(
                        postId: postId,
                        selectedWho: selectedWho,
                        selectedWhere: selectedWhere,
                        selectedWhat: selectedWhat,
                        selectedMore: selectedMore,
                        selectedMoreString: selectedMoreString,
                        isCore: isCore
                    )
                }
            }
    }
}

#Preview {
    WriteTabContainer()
}
