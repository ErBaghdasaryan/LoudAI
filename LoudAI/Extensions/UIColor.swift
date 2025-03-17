//
//  UIColor.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    static func interpolate(from color1: UIColor, to color2: UIColor, progress: CGFloat) -> UIColor {
            let progress = max(0, min(progress, 1))
            var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
            var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

            color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

            return UIColor(
                red: r1 + (r2 - r1) * progress,
                green: g1 + (g2 - g1) * progress,
                blue: b1 + (b2 - b1) * progress,
                alpha: a1 + (a2 - a1) * progress
            )
        }
}
