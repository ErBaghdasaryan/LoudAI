//
//  UIImage.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 11.04.25.
//
import UIKit

public extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized ?? self
    }
}
