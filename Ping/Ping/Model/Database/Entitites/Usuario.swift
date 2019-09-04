//
//  Usuario.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 03/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

public class Usuario: NSObject, EntityObject {
    public static let recordType = "Usuario"
    public private(set) var record: CKRecord
    public private(set) var idUsuario: DataProperty<String>
    public private(set) var campainhas: [Campainha] = []

    public init(record: CKRecord) {
        self.record = record
        self.idUsuario = DataProperty(record: record, key: "idUsuario")
        super.init()
    }

    public func addToCampainhas(_ value: Campainha) {
        campainhas.append(value)
    }

    public func removeFromCampainhas(_ value: Campainha) {
        if let index = campainhas.firstIndex(of: value) {
            campainhas.remove(at: index)
        }
    }
}
