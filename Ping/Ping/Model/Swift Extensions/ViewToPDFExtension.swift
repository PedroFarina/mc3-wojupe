//
//  ViewToPDFExtension.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 11/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public func toPDF(fileName: String) -> NSData? {
        let pdfData = NSMutableData()
        let pdfMetadata = [
            kCGPDFContextCreator: "QR Bell",
            kCGPDFContextTitle: "Campainha".localized()
        ]

        UIGraphicsBeginPDFContextToData(pdfData, self.bounds, pdfMetadata)
        UIGraphicsBeginPDFPage()

        guard let pdfContext = UIGraphicsGetCurrentContext() else {
            return nil
        }

        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()

        return pdfData
    }
}
