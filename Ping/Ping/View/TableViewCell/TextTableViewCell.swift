//
//  TextTableViewCell.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 28/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

@IBDesignable public class TextTableViewCell: UITableViewCell, UITextFieldDelegate {
    public static var xib: String = "TextTableViewCell"
    public static var identifier: String = "TextTableViewCell"
    public var completionCharacters: ((String?) -> Void)?

    @IBOutlet public weak var txtField: UITextField!
    @IBInspectable var maxCharacters: Int = -1
    public override func awakeFromNib() {
        self.isAccessibilityElement = true
        self.accessibilityNavigationStyle = .combined
        self.accessibilityLabel = txtField.accessibilityLabel
        self.accessibilityTraits = txtField.accessibilityTraits
        txtField.delegate = self
        txtField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        txtField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
    }

    @IBInspectable public var txtText: String? {
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

    var tap: UITapGestureRecognizer?
    var view: UIView?
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view = topController.view
            topController.view.addGestureRecognizer(tap!)
        }
    }

    @objc private func dismissKeyboard() {
        view?.endEditing(true)
        if let tap = tap {
            view?.removeGestureRecognizer(tap)
        }
    }

    @objc private func textFieldEditingDidEnd(_ textField: UITextField) {
        if maxCharacters != -1 && textField.text?.count !=  maxCharacters {
            textField.text = ""
        }
        if let tap = tap {
            view?.removeGestureRecognizer(tap)
        }
    }

    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        guard maxCharacters > 0, let text = textField.text else {
            return
        }
        if text.count == maxCharacters {
            completionCharacters?(text)
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

        if newString.length < maxLength {
            return true
        } else if newString.length == maxLength {
            return true
        }
        return false
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        completionCharacters?(textField.text)
        return true
    }
}
