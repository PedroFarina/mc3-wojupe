//
//  DataFetchAnswer.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 03/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

public enum DataFetchAnswer {
    case fail(description:String)
    case successful(results:[CKRecord]?)
}
