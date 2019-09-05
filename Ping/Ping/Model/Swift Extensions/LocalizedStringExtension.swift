//
//  LocalizedString.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 30/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
