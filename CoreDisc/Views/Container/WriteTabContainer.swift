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
                case .select:
                    PostWriteDiaryView()
                case .summary:
                    PostDiaryCheckView()
                }
            }
    }
}

#Preview {
    WriteTabContainer()
}
