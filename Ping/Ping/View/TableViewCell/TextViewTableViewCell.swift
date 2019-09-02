//
//  TextViewTableViewCell.swift
//  Ping
//
//  Created by Julia Santos on 30/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class TextViewTableViewCell: UITableViewCell {
    @IBOutlet public weak var txtView: UITextView!

    public var txtText: String? {
        get {
            return txtView.text
        }
        set {
            txtView.text = newValue
        }
    }
}
