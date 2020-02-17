//
//  Visitante.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 17/01/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import CloudKit

public struct Visitante {
    let name: String
    let date: Date

    public init?(record: CKRecord) {
        guard let name = record["NomeVisitante"] as? String,
            let date = record.creationDate else {
                return nil
        }
        self.name = name
        self.date = date
    }
}
