//
//  GrupoCampainha.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 06/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

public class GrupoCampainha: NSObject, EntityObject {
    public static let recordType: String = "GrupoCampainha"
    public var record: CKRecord

    public private(set) var campainha: ReferenceField<Campainha>
    public private(set) var usuarios: ReferenceList<Usuario>

    public init(campainha: Campainha, record: CKRecord) {
        self.record = record
        self.campainha = ReferenceField(record: record, key: "Campainha", action: .deleteSelf)
        self.usuarios = ReferenceList(record: record, key: "Usuarios")
        super.init()

        campainha.setGrupo(self)
    }

    internal func setCampainha(_ campainha: Campainha) {
        self.campainha.value = campainha
    }

    internal func removeCampainha() {
        campainha.value = nil
    }

    internal func addUsuario(_ usuario: Usuario) {
        if !usuarios.contains(usuario) {
            usuarios.append(usuario, action: .deleteSelf)
        }
    }

    internal func removeUsuario(_ usuario: Usuario) {
        if let index = usuarios.firstIndex(of: usuario) {
            usuarios.remove(at: index)
        }
    }

    public func removeUsuarios() {
        for usuario in usuarios.references {
            usuario.removeFromGrupo(self)
        }
    }

    public func addUsuarios(_ usuarios: [Usuario]) {
        for usuario in usuarios {
            usuario.addToGrupo(self)
        }
    }
}
