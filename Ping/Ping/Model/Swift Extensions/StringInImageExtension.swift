//
//  StringInImageExtension.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 11/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Foundation

extension String {
    func appendToImage(_ img: UIImage, at point: CGPoint, color: UIColor = .black,
                       font: UIFont = UIFont.systemFont(ofSize: 12)) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(img.size, false, scale)

        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]

        img.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: img.size))

        let rect = CGRect(origin: point, size: img.size)

        (self as NSString).draw(in: rect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return newImage
    }
}
