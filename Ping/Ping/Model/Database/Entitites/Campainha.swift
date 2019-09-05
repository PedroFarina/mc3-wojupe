//
//  Campainha.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 03/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

public class Campainha: NSObject, EntityObject {
    public static let recordType = "Campainha"
    public private(set) var record: CKRecord
    public private(set) var dono: Usuario
    public private(set) var titulo: DataProperty<String>
    public private(set) var descricao: DataProperty<String>
    public private(set) var senha: DataProperty<String>
    public private(set) var URL: DataProperty<String>

    public init(dono: Usuario, record: CKRecord) {
        self.record = record
        self.dono = dono
        self.titulo = DataProperty(record: record, key: "Titulo")
        self.descricao = DataProperty(record: record, key: "Descricao")
        self.senha = DataProperty(record: record, key: "Senha")
        self.URL = DataProperty(record: record, key: "URL")
        super.init()

        dono.addToCampainhas(self)
    }

    public func renewURL() {
        //Fazer requerimento e atribuir a URL
    }
}
