//
//  ButtonTableViewCell.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 28/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class ButtonTableViewCell: UITableViewCell {
    @IBOutlet private weak var lblBtn: UILabel!

    @IBInspectable public var buttonText: String? {
        get {
            return lblBtn.text
        }
        set {
            lblBtn.text = newValue
        }
    }
}
