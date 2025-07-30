//
//  Font.swift
//  CoreDisc
//
//  Created by 김미주 on 7/3/25.
//

import Foundation
import SwiftUI

struct TextStyle {
    let font: Font
    let kerning: CGFloat
    let lineSpacing: CGFloat
}

// MARK: - Font Extension
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
}

// MARK: - View Extension
struct SetTextStyle: ViewModifier {
    let style: TextStyle
    
    func body(content: Content) -> some View {
        content
            .font(style.font)
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
    }
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        modifier(SetTextStyle(style: style))
    }
}

// MARK: - TextStyle Extension
extension TextStyle {
    // MARK: - Pretendard
    
    // extraBold 800
    static var Title_Text_Ko = TextStyle(
        font: .pretendard(type: .extraBold, size: 36),
        kerning: -2,
        lineSpacing: 7
    )
    
    static var Title2_Text_Ko = TextStyle(
        font: .pretendard(type: .extraBold, size: 24),
        kerning: -2,
        lineSpacing: 19
    )
    
    static var Title3_Text_Ko = TextStyle(
        font: .pretendard(type: .extraBold, size: 32),
        kerning: -0.7,
        lineSpacing: 13
    )
    
    // bold 700
    static var Q_Main = TextStyle(
        font: .pretendard(type: .bold, size: 16),
        kerning: -0.7,
        lineSpacing: 8
    )
    
    static var Button = TextStyle(
        font: .pretendard(type: .bold, size: 16),
        kerning: -0.7,
        lineSpacing: 8
    )
    
    static var Bold_Text = TextStyle(
        font: .pretendard(type: .bold, size: 14),
        kerning: -0.7,
        lineSpacing: 8
    )
    
    // medium 500
    static var Post_Sub = TextStyle(
        font: .pretendard(type: .medium, size: 14),
        kerning: -1,
        lineSpacing: 7
    )
    
    static var Q_Sub = TextStyle(
        font: .pretendard(type: .medium, size: 12),
        kerning: 0,
        lineSpacing: 4
    )
    
    static var login_info = TextStyle(
        font: .pretendard(type: .medium, size: 12),
        kerning: 0,
        lineSpacing: 4
    )
    
    static var Button_s = TextStyle(
        font: .pretendard(type: .medium, size: 12),
        kerning: 0,
        lineSpacing: 4
    )
    
    static var A_Main = TextStyle(
        font: .pretendard(type: .medium, size: 12),
        kerning: 0,
        lineSpacing: 3
    )
    
    static var login_alert = TextStyle(
        font: .pretendard(type: .medium, size: 10),
        kerning: 0,
        lineSpacing: 6
    )
    
    static var Small_Text_10 = TextStyle(
        font: .pretendard(type: .medium, size: 10),
        kerning: 0,
        lineSpacing: 6
    )
    
    static var Post_Thumbnail_text = TextStyle(
        font: .pretendard(type: .medium, size: 8),
        kerning: -0.7,
        lineSpacing: 4
    )
    
    
    // regular 400
    static var Sub_Text_Ko = TextStyle(
        font: .pretendard(type: .regular, size: 16),
        kerning: -0.7,
        lineSpacing: 8
    )
    
    static var Modal_Text = TextStyle(
        font: .pretendard(type: .regular, size: 14),
        kerning: -0.7,
        lineSpacing: -4
    )
    
    static var Texting_Q = TextStyle(
        font: .pretendard(type: .regular, size: 12),
        kerning: -0.7,
        lineSpacing: 4
    )
    
    static var Q_pick = TextStyle(
        font: .pretendard(type: .regular, size: 12),
        kerning: 0,
        lineSpacing: 12
    )
    
    static var Small_Text_6 = TextStyle(
        font: .pretendard(type: .regular, size: 6),
        kerning: -0.7,
        lineSpacing: 2
    )
    
    // light 300
    static var Small_Text_8 = TextStyle(
        font: .pretendard(type: .light, size: 8),
        kerning: 0,
        lineSpacing: 2
    )
    
    // MARK: - Primeform
    
    // Heavy 800
    static var Title_Text_Eng = TextStyle(
        font: .primeform(type: .heavy, size: 36),
        kerning: -2,
        lineSpacing: 7
    )
    
    static var Id_Find = TextStyle(
        font: .primeform(type: .heavy, size: 24),
        kerning: -0.7,
        lineSpacing: 3
    )
    
    static var Post_Title = TextStyle(
        font: .primeform(type: .heavy, size: 24),
        kerning: -2,
        lineSpacing: 7
    )
    
    static var Post_Time = TextStyle(
        font: .primeform(type: .heavy, size: 24),
        kerning: -1,
        lineSpacing: 7
    )
    
    static var Pick_Q_Eng_bold = TextStyle(
        font: .primeform(type: .heavy, size: 16),
        kerning: -0.7,
        lineSpacing: 27
    )
    
    static var category_bar = TextStyle(
        font: .primeform(type: .heavy, size: 13),
        kerning: 1,
        lineSpacing: 29
    )
    
    // Semibold 600
    static var Pick_Q_Eng = TextStyle(
        font: .primeform(type: .semiBold, size: 16),
        kerning: 0,
        lineSpacing: 4
    )
    

    static var Post_UserID = TextStyle(
        font: .primeform(type: .semiBold, size: 8),
        kerning: 0,
        lineSpacing: 2
    )
    
    static var Comment_ID = TextStyle(
        font: .primeform(type: .semiBold, size: 8),
        kerning: -0.7,
        lineSpacing: 2
    )
    
    // medium 500
    static var Small_Text = TextStyle(
        font: .primeform(type: .medium, size: 8),
        kerning: -0.7,
        lineSpacing: 2
    )
    
    // regular 400
    static var Post_Id = TextStyle(
        font: .primeform(type: .regular, size: 16),
        kerning: -0.7,
        lineSpacing: 2
    )
    
    // light 300
    static var light_eng = TextStyle(
        font: .primeform(type: .light, size: 16),
        kerning: 0,
        lineSpacing: 4
    )
}
