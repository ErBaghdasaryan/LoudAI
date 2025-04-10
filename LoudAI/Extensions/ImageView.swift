//
//  ImageView.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 31.03.25.
//
import UIKit

class DashedImageView: UIImageView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = nil
        borderLayer.lineDashPattern = [24, 16]
        borderLayer.frame = bounds
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath

        layer.addSublayer(borderLayer)
    }
}

