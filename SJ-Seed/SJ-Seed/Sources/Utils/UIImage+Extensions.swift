//
//  UIImage+Extensions.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/26/25.
//

import Foundation
import UIKit

extension UIImage {
    // 이미지를 특정 너비에 맞춰 비율대로 줄이는 함수
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
