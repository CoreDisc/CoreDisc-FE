//
//  WriteTabContainer.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import SwiftUI

struct WriteTabContainer: View {
    @State private var router = NavigationRouter<WriteRoute>()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            PostWriteView()
                .navigationDestination(for: WriteRoute.self) { route in
                    switch route {
                    case .answer:
                        PostWriteView()
                    case .select:
                        PostWriteDiaryView()
                    case .summary:
                        PostDiaryCheckView()
                    }
                }
        }
        .environment(router)
    }
}

#Preview {
    WriteTabContainer()
}
