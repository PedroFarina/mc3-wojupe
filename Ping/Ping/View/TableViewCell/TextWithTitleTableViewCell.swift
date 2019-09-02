//
//  TextWithTitleTableViewCell.swift
//  Ping
//
//  Created by Wolfgang Walder on 02/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

@IBDesignable public class TextWithTitleTableViewCell: UITableViewCell, UITextFieldDelegate {
    public static var xib: String = "TextWithTitleTableViewCell"
    public static var identifier: String = "TextWithTitleTableViewCell"
    public var completionCharacters: ((String?) -> Void)?

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBInspectable var maxCharacters: Int = -1

    public override func awakeFromNib() {
        txtField.delegate = self
    }

    public var lblText: String? {
        get {
            return lblTitle.text
        }
        set {
            lblTitle.text = newValue
        }
    }

    public var txtText: String? {
        get {
            return txtField.text
        }
        set {
            txtField.text = newValue
        }
    }

    public var txtPlaceholder: String? {
        get {
            return txtField.placeholder
        }
        set {
            txtField.placeholder = newValue
        }
    }

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let maxLength = UInt32(exactly: maxCharacters as NSNumber) else {
            return true
        }

        guard let currentString: NSString = textField.text as NSString? else {
            return true
        }
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString

        if newString.length >= maxLength {
            completionCharacters?(textField.text)
        }
        return newString.length <= maxLength
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        completionCharacters?(textField.text)
        return true
    }
}
