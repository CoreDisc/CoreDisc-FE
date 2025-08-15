//
//  Image.swift
//  CoreDisc
//
//  Created by 정서영 on 8/15/25.
//

import SwiftUI

extension UIImage {
    func resizedWithPadding(targetSize: CGFloat) -> UIImage {
        let scale = targetSize / min(size.width, size.height)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: targetSize, height: targetSize))
        return renderer.image { _ in
            let origin = CGPoint(
                x: (targetSize - newSize.width) / 2,
                y: (targetSize - newSize.height) / 2
            )
            self.draw(in: CGRect(origin: origin, size: newSize))
        }
    }
}
