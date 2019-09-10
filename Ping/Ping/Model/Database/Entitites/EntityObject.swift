//
//  DataEntity.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 04/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

public protocol EntityObject: NSObject {
    static var recordType: String { get }
    var record: CKRecord { get }
}
