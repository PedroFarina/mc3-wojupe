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
    public private(set) var idSubscription: DataProperty<String?>
    public private(set) var campainhas: ReferenceList<Campainha>
    public private(set) var grupos: ReferenceList<GrupoCampainha>

    public init(record: CKRecord) {
        self.record = record
        self.idUsuario = DataProperty(record: record, key: "idUsuario")
        self.idSubscription = DataProperty(record: record, key: "idSubscription")
        self.campainhas = ReferenceList(record: record, key: "Campainhas")
        self.grupos = ReferenceList(record: record, key: "Grupos")
        super.init()
    }

    public func addCampainha(_ value: Campainha) {
        if !campainhas.contains(value) {
            campainhas.append(value, action: .none)
            value.setDono(self)
        }
        DataController.shared().saveModifications(obj: [self, value])
    }

    public func removeCampainha(_ value: Campainha) {
        if let index = campainhas.firstIndex(of: value) {
            campainhas.remove(at: index)
            value.removeDono()
        }
        DataController.shared().saveModifications(obj: [self, value])
    }

    public func deleteCampainha(_ value: Campainha) {
        if let index = campainhas.firstIndex(of: value) {
            campainhas.remove(at: index)
            value.removeDono()
        }
    }

    public func addToGrupo(_ value: GrupoCampainha) {
        if !grupos.contains(value) {
            grupos.append(value, action: .none)
            value.addUsuario(self)
        }
        DataController.shared().saveModifications(obj: [self, value])
    }

    public func removeFromGrupo(_ value: GrupoCampainha) {
        if let index = grupos.firstIndex(of: value) {
            grupos.remove(at: index)
            value.removeUsuario(self)
        }
        DataController.shared().saveModifications(obj: [self, value])
    }

    public func deleteFromGrupo(_ value: GrupoCampainha) {
        if let index = grupos.firstIndex(of: value) {
            grupos.remove(at: index)
            value.removeUsuario(self)
        }
    }
}
