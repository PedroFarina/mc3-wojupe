//
//  TitleDetailDisclosure.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 22/01/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class TitleDetailDownDisclosureTableViewCell: UITableViewCell {
    public static var xib: String = "TitleDetailDownDisclosureTableViewCell"
    public static var identifier: String = "TitleDetailDownDisclosureTableViewCell"

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet private weak var myDisclosure: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!

    public func tap() {
        lblDetail.isHidden = !lblDetail.isHidden
        guard let image = myDisclosure.image else {
            self.setNeedsDisplay()
            return
        }
        myDisclosure.image = image.rotate(radians: .pi)
        setNeedsDisplay()
    }

    public var titleText: String? {
        get {
            return lblTitle.text
        }
        set {
            lblTitle.text = newValue
        }
    }
    public var detailText: String? {
        get {
            return lblDetail.text
        }
        set {
            lblDetail.text = newValue
        }
    }
}
