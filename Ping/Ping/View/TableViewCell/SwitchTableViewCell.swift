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
    public lazy var onOff: UISwitch = {
        let onOff = UISwitch()
        onOff.addTarget(self, action: #selector(onOffOccur), for: .valueChanged)
        onOff.onTintColor = #colorLiteral(red: 0.2156862745, green: 0.5019607843, blue: 0.5607843137, alpha: 1)

        return onOff
    }()

    public var onOffChanged: ((UISwitch) -> Void)?

    override func awakeFromNib() {
        self.isAccessibilityElement = true
        self.accessibilityNavigationStyle = .combined
        self.accessibilityLabel = lblText
        self.accessoryView = onOff
    }

    public var lblText: String? {
        get {
            return lblTitle.text
        }
        set {
            lblTitle.text = newValue
            self.accessibilityLabel = newValue
        }
    }
    @objc public func onOffOccur() {
        guard let onOffChanged = onOffChanged else {
            return
        }
        onOffChanged(onOff)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
