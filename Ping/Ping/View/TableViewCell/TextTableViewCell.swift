//
//  TextTableViewCell.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 28/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    @IBOutlet public weak var txtField: UITextField!

    @IBInspectable public var txtText: String? {
        get {
            return txtField.text
        }
        set {
            txtField.text = newValue
        }
    }
}
