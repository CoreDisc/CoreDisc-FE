//
//  ReportTabContainer.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import SwiftUI

struct ReportTabContainer: View {
    var body: some View {
        ReportMainView()
            .navigationDestination(for: ReportRoute.self) { route in
                switch route {
                case .museum:
                    ReportMainView()
                case .cover(let discId):
                    ChangeCoverView(discId: discId)
                case .detail(let year, let month):
                    ReportDetailView(year: year, month: month)
                case .summary(let SummaryYear, let SummaryMonth):
                    ReportSummaryView(SummaryYear: SummaryYear, SummaryMonth: SummaryMonth)
                }
            }
    }
}

#Preview {
    ReportTabContainer()
}
