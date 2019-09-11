//
//  DataActionsAnswer.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 30/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

public enum DataActionAnswer {
    case fail(error: CKError, description: String)
    case successful
}
