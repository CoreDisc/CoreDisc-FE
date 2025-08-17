//
//  ReportRoute.swift
//  CoreDisc
//
//  Created by 김미주 on 8/17/25.
//

import Foundation

enum ReportRoute: Hashable {
    case museum
    case cover(discId: Int)
    case detail(year: Int, month: Int)
    case summary(SummaryYear: Int, SummaryMonth: Int)
}
