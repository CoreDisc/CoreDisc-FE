//
//  Navigation.swift
//  CoreDisc
//
//  Created by 김미주 on 8/12/25.
//

import Foundation
import UIKit

// 스와이프시 뷰 닫히게
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
