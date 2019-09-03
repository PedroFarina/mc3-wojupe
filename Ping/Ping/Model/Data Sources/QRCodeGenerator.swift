//
//  QRCodeGenerator.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 03/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class QRCodeGenerator {
    private init() {
    }

    public static func qrImage(from string: String) -> UIImage? {
        return qrImage(from: string, using: .black)
    }

    public static func qrImage(from string: String, using color: UIColor) -> UIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        let qrData = string.data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")
        let qrTransform = CGAffineTransform(scaleX: 20, y: 20)

        if let img = qrFilter.outputImage?.transformed(by: qrTransform).tinted(using: color) {
            return UIImage(ciImage: img)
        }
        return nil
    }
}
