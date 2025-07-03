//
//  Font.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import Foundation
import SwiftUI

extension Font {
    // MARK: - Pretendard
    enum Pretendard {
        case black
        case extraBold
        case bold
        case semiBold
        case medium
        case regular
        case light
        case extraLight
        case thin
        
        var value: String {
            switch self {
            case .black:
                return "Pretendard-Black"
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .bold:
                return "Pretendard-Bold"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .light:
                return "Pretendard-Light"
            case .extraLight:
                return "Pretendard-ExtraLight"
            case .thin:
                return "Pretendard-Thin"
            }
        }
    }
    
    static func pretendard(type: Pretendard, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    // semiBold 600
    static var Q_Main: Font { // PretendardSemiBold16
        return .pretendard(type: .semiBold, size: 16)
    }
    
    static var PretendardSemiBold10: Font {
        return .pretendard(type: .semiBold, size: 10)
    }
    
    // Medium 500
    static var Q_Sub: Font { // PretendardMedium12
        return .pretendard(type: .medium, size: 12)
    }
    
    // regular 400
    static var Sub_Text: Font { // PretendardRegular16
        return .pretendard(type: .regular, size: 16)
    }
    
    static var PretendardRegular12: Font {
        return .pretendard(type: .regular, size: 12)
    }

    // MARK: - Primeform
    enum Primeform {
        case black
        case heavy
        case bold
        case semiBold
        case medium
        case regular
        case light
        case extraLight
        case thin
        
        var value: String {
            switch self {
            case .black:
                return "PrimeformProDemo-Black"
            case .heavy:
                return "PrimeformProDemo-Heavy"
            case .bold:
                return "PrimeformProDemo-Bold"
            case .semiBold:
                return "PrimeformProDemo-SemiBold"
            case .medium:
                return "PrimeformProDemo-Medium"
            case .regular:
                return "PrimeformProDemo-Regular"
            case .light:
                return "PrimeformProDemo-Light"
            case .extraLight:
                return "PrimeformProDemo-ExtraLight"
            case .thin:
                return "PrimeformProDemo-Thin"
            }
        }
    }
    
    static func primeform(type: Primeform, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    // Heavy 800
    static var Title_Text: Font { // PrimeformHeavy36
        return .primeform(type: .heavy, size: 36)
    }
    
    static var PrimeformHeavy13: Font {
        return .primeform(type: .heavy, size: 13)
    }
    
    // Semibold 600
    static var PrimeformSemiBold8: Font {
        return .primeform(type: .semiBold, size: 8)
    }
}
