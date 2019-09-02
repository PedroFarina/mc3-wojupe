//
//  CampainhaPropertiesTableViewDelegate.swift
//  Ping
//
//  Created by Wolfgang Walder on 02/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class CampainhaPropertiesTableViewDelegate: NSObject, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return 44
        }
        if cell.isHidden {
            return 0
        }
        return 44
    }
}
