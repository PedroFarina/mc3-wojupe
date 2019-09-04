//
//  DataController.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 30/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit
import UIKit

public class DataController {
    private let container: CKContainer
    private let privateDB: CKDatabase
    private let sharedDB: CKDatabase
    private let publicDB: CKDatabase

    private var _usuario: Usuario?
    private var _campainhas: [Campainha] = []
    // MARK: Acessores de campainhas

    // MARK: Criar campainha
    public func createCampainha(dono: Usuario, titulo: String, descricao: String, url: String) -> Campainha {
        let campainha = Campainha(dono: dono)
        campainha.titulo.value = titulo
        campainha.descricao.value = descricao
        campainha.URL.value = url
        _campainhas.append(campainha)
        saveObject(database: privateDB, object: campainha, completionHandler: { (answer) in
            switch answer {
            case .fail(let description):
                fatalError(description)
            default:
                return
            }
        })
        return campainha
    }

    // MARK: Editar campainha
    public func editCampainha(target campainha: Campainha, newTitulo titulo: String?, newSenha senha: String?,
                              newDescricao descricao: String?, newUrl url: String?) {
        var hasModifications: Bool = false

        //Vendo se alteraremos o titulo
        if let titulo = titulo, titulo != campainha.titulo {
            campainha.titulo.value = titulo
            hasModifications = true
        }
        //Vendo se alteramos a senha
        if let senha = senha, senha != campainha.senha {
            campainha.senha.value = senha
            hasModifications = true
        }
        //Vendo se alteraremos a descricao
        if let descricao = descricao, descricao != campainha.descricao {
            campainha.descricao.value = descricao
            hasModifications = true
        }
        //Vendo se alteraremos a campainha
        if let url = url, url != campainha.URL {
            campainha.URL.value = url
            hasModifications = true
        }

        //Se algo foi alterado, salvamos
        if hasModifications {
            saveObject(database: privateDB, object: campainha, completionHandler: { (answer) in
                switch answer {
                case .fail(let description):
                    fatalError(description)
                default:
                    return
                }
            })
        }
    }

    // MARK: Remover campainha
    public func removeCampainha(target campainha: Campainha) {
        deleteObject(database: privateDB, object: campainha) { (answer) in
            switch answer {
            case .fail(let description):
                fatalError(description)
            default:
                return
            }
        }
    }

    // MARK: Acessores de Usuario
    public func createUsuario() -> Usuario {
        let usuario = Usuario()
        saveObject(database: privateDB, object: usuario) { (answer) in
            switch answer {
            case .fail(let description):
                fatalError(description)
            default:
                return
            }
        }
        return usuario
    }

    // MARK: Singleton Properties
    private init() {
        container = CKContainer.default()
        privateDB = container.privateCloudDatabase
        sharedDB = container.sharedCloudDatabase
        publicDB = container.publicCloudDatabase
    }

    class func shared() -> DataController {
        return sharedModelController
    }

    private static var sharedModelController: DataController = {
        let mController = DataController()
        return mController
    }()

    // MARK: CloudKit

    // MARK: Saving Objects
    private func saveObject(database: CKDatabase, object: EntityObject,
                            completionHandler: @escaping ((DataActionAnswer) -> Void)) {
        database.save(object.record) { (_, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.fail(description:
                        "Erro em salvar o objeto na Cloud - Save: \(String(describing: error))"))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(.successful)
            }
            return
        }
    }

    // MARK: Deleting Objects
    private func deleteObject(database: CKDatabase, object: EntityObject,
                              completionHandler: @escaping ((DataActionAnswer) -> Void)) {
        database.delete(withRecordID: object.record.recordID) { (_, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.fail(description:
                        "Erro em deletar o objeto na Cloud - Delete: \(String(describing: error))"))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(.successful)
            }
            return
        }
    }

    // MARK: Fetching
    private func fetch(recordType: String, completionHandler: @escaping (DataFetchAnswer) -> Void) {
        let predicate = NSPredicate(value: true)
        fetch(query: CKQuery(recordType: recordType, predicate: predicate), completionHandler: completionHandler)
    }

    private func fetch(query: CKQuery, completionHandler: @escaping (DataFetchAnswer) -> Void) {
        fetch(query: query, database: privateDB, completionHandler: completionHandler)
    }

    private func fetch(query: CKQuery, database: CKDatabase, completionHandler: @escaping (DataFetchAnswer) -> Void ) {
        database.perform(query, inZoneWith: nil) { results, error in
            //Vendo se não tivemos erros
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.fail(description:
                        "Erro no Query da Cloud - Fetch: \(String(describing: error))"))
                }
                return
            }

            DispatchQueue.main.async {
                completionHandler(.successful(results: results))
            }
        }
    }
}

extension Usuario {
    fileprivate convenience override init() {
        let record = CKRecord(recordType: Usuario.recordType)
        self.init(record: record)
        idUsuario.value = UUID().uuidString
    }
}

extension Campainha {
    fileprivate convenience init(dono: Usuario) {
        let record = CKRecord(recordType: Campainha.recordType)
        self.init(dono: dono, record: record)
    }
}
