//
//  TextTableViewCell.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 28/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet public weak var txtField: UITextField!
    override func awakeFromNib() {
        txtField.delegate = self
    }

    @IBInspectable public var txtText: String? {
        get {
            return txtField.text
        }
        set {
            txtField.text = newValue
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
