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
    public private(set) var dono: ReferenceField<Usuario>
    public private(set) var grupo: ReferenceField<GrupoCampainha>
    public private(set) var titulo: DataProperty<String>
    public private(set) var descricao: DataProperty<String>
    public private(set) var URL: DataProperty<String>

    public init(dono: Usuario, record: CKRecord) {
        self.record = record
        self.dono = ReferenceField(record: record, key: "Dono", action: .deleteSelf)
        self.grupo = ReferenceField(record: record, key: "Grupo", action: .none)
        self.titulo = DataProperty(record: record, key: "Titulo")
        self.descricao = DataProperty(record: record, key: "Descricao")
        self.URL = DataProperty(record: record, key: "URL")
        super.init()
    }

    internal func setDono(_ dono: Usuario) {
        self.dono.value = dono
    }

    internal func removeDono() {
        self.dono.value = nil
    }

    public func setGrupo(_ grupo: GrupoCampainha) {
        if self.grupo.value != grupo {
            self.grupo.value = grupo
            grupo.setCampainha(self)
        }
    }

    public func removeGrupo() {
        if let grupo = grupo.value {
            self.grupo.value = nil
            grupo.removeCampainha()
        }
    }

    public func renewURL() {
        //Fazer requerimento e atribuir a URL
        guard let grupo = grupo.value else {
            return
        }
        grupo.removeUsuarios()
        DataController.shared().removeGrupoCampainha(target: grupo)
        let grupoNovo = DataController.shared().createGrupoCampainha(owner: self)
        setGrupo(grupoNovo)
        if let usuario = dono.value {
            usuario.addToGrupo(grupoNovo)
        }
    }
}
