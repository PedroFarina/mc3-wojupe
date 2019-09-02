//
//  SwitchTableViewCell.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 28/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    static let xib: String = "SwitchTableViewCell"
    static let identifier: String = "SwitchTableViewCell"

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var onOff: UISwitch!
    public var onOffChanged: ((UISwitch) -> Void)?

    public var lblText: String? {
        get {
            return lblTitle.text
        }
        set {
            lblTitle.text = newValue
        }
    }

    @IBAction func onOffOccur (_  sender: UISwitch) {
        guard let onOffChanged = onOffChanged else {
            return
        }
        onOffChanged(sender)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
