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

    private var completionHandlerDefault: (DataActionAnswer) -> Void = {
        (answer) in
        switch answer {
        case .fail(let description):
            fatalError(description)
        default:
            return
        }
    }

    private var recordsToSave: [EntityObject] = []

    public var refreshing: Bool = false {
        didSet {
            if !refreshing {
                completionHandlers = []
            }
        }
    }
    private var completionHandlers:[() -> Void] = []

    private var _usuario: Usuario?
    private var _campainhas: [Campainha] = []
    private var _gruposCampainhas: [GrupoCampainha] = []

    public func getEntityByID(_ entityId: CKRecord.ID) -> EntityObject? {
        if _usuario?.record.recordID == entityId {
            return _usuario
        }

        if let entity = _campainhas.first(where: { (ent) -> Bool in
            return ent.record.recordID == entityId
        }) {
            return entity
        }

        if let entity = _gruposCampainhas.first(where: { (ent) -> Bool in
            return ent.record.recordID == entityId
        }) {
            return entity
        }

        return nil
    }

    fileprivate var usuarioID: CKRecord.ID?
    public var getUsuario: Usuario? {
        return _usuario
    }
    public var getCampainhas: [Campainha] {
        return _campainhas
    }
    // MARK: Acessores de campainhas

    // MARK: Criar campainha
    public func createCampainha(dono: Usuario, titulo: String, descricao: String, url: String) -> Campainha {
        let campainha: Campainha = Campainha(dono: dono)
        campainha.titulo.value = titulo
        campainha.descricao.value = descricao
        campainha.URL.value = url
        _campainhas.append(campainha)
        let grupo = createGrupoCampainha(owner: campainha)

        dono.addCampainha(campainha)
        dono.addToGrupo(grupo)

        recordsToSave.append(contentsOf: [dono, campainha])
        saveData(database: publicDB)

        return campainha
    }

    // MARK: Salvar campainha
    private func saveCampainha(campainha: Campainha) {
        saveObject(database: publicDB, object: campainha, completionHandler: completionHandlerDefault)
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
        if let senha = senha, let grupo = campainha.grupo.value, senha != grupo.senha {
            grupo.senha.value = senha
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
            saveCampainha(campainha: campainha)
        }
    }

    // MARK: Remover campainha
    public func removeCampainha(target campainha: Campainha) {
        if let index = _campainhas.firstIndex(of: campainha) {
            _campainhas.remove(at: index)
        }
        deleteObject(database: publicDB, object: campainha, completionHandler: completionHandlerDefault)
    }

    // MARK: Acessores de Grupos de Campainha

    // MARK: Criar Grupo de Campainha
    public func createGrupoCampainha(owner campainha: Campainha) -> GrupoCampainha {
        let grupo = GrupoCampainha(campainha: campainha)
        _gruposCampainhas.append(grupo)

        recordsToSave.append(contentsOf: [grupo, campainha])
        saveData(database: publicDB)

        return grupo
    }

    // MARK: Salvar grupo de campainha
    private func saveGrupo(grupo: GrupoCampainha) {
        saveObject(database: publicDB, object: grupo, completionHandler: completionHandlerDefault)
    }

    // MARK: Editar Grupo de Campainha
    public func editarGrupoCampainha(target grupo: GrupoCampainha, newCampainha campainha: Campainha?,
                                     newUsuarios usuarios: [Usuario]?) {
        var hasModifications: Bool = false

        if let usuarios = usuarios, usuarios != grupo.usuarios {
            for userReference in grupo.usuarios.references {
                recordsToSave.append(userReference)
            }
            for newUser in usuarios {
                if !recordsToSave.contains(where: { (aUser) -> Bool in
                    return newUser == aUser
                }) {
                    recordsToSave.append(newUser)
                }
            }
            saveData(database: privateDB)

            grupo.removeUsuarios()
            grupo.addUsuarios(usuarios)
            hasModifications = true
        }

        if let campainha = campainha, campainha != grupo.campainha {
            if let oldCampainha = grupo.campainha.value {
                recordsToSave.append(oldCampainha)
            }
            recordsToSave.append(campainha)

            grupo.campainha.value?.removeGrupo()
            campainha.setGrupo(grupo)
            hasModifications = true
        }

        if hasModifications {
            recordsToSave.append(grupo)
            saveData(database: publicDB)
        }
    }

    // MARK: Remover Grupo de Campainha
    public func removeGrupoCampainha(target grupo: GrupoCampainha) {
        if let index = _gruposCampainhas.firstIndex(of: grupo) {
            _gruposCampainhas.remove(at: index)
        }
        deleteObject(database: publicDB, object: grupo, completionHandler: completionHandlerDefault)
    }

    // MARK: Acessores de Usuario

    // MARK: Criar usuário
    private func createUsuario() -> Usuario {
        if let usuario = _usuario {
            return usuario
        }
        let usuario: Usuario = Usuario()
        saveUsuario(usuario: usuario)
        return usuario
    }

    // MARK: Salvar usuário
    public func saveUsuario(usuario: Usuario) {
        saveObject(database: publicDB, object: usuario, completionHandler: completionHandlerDefault)
    }

    // MARK: Fetch Usuario
    private func fetchUsuario(fetchCampainhas: Bool, completionHandler: @escaping () -> Void) {
        if let userID = usuarioID {
            let predicate = NSPredicate(format: "idUsuario == %@", userID.recordName)
            let query = CKQuery(recordType: "Usuario", predicate: predicate)
            self.fetch(query: query, completionHandler: { (answer) in
                switch answer {
                case .fail(let description):
                    fatalError(description)
                case .successful(let results):
                    guard let results = results, results.count <= 1 else {
                        fatalError("Não foi possível dar fetch no Usuario " +
                            "ou havia mais de um usuário cadastrado na mesma conta.")
                    }
                    if results.isEmpty && self._usuario == nil {
                        self._usuario = self.createUsuario()
                    } else {
                        self._usuario = Usuario(record: results[0])
                    }
                    if fetchCampainhas {
                        self.fetchCampainhas(completionHandler: completionHandler)
                    } else {
                        for comp in self.completionHandlers {
                            comp()
                        }
                        self.refreshing = false
                        completionHandler()
                    }
                }
            })
        }
    }

    // MARK: Fetch Campainhas
    private func fetchCampainhas(completionHandler: @escaping () -> Void) {
        guard let usuario = _usuario else {
            fatalError("Não existe um usuario cadastrado.")
        }
        _campainhas = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Campainha.recordType, predicate: predicate)
        fetch(query: query, database: publicDB) { (answer) in
            switch answer {
            case .fail(let description):
                fatalError(description)
            case .successful(let results):
                guard let results = results else {
                    fatalError("Não foi poossivel dar fetch nas Campainhas")
                }
                for result in results {
                    self._campainhas.append(Campainha(dono: usuario, record: result))
                }
                for comp in self.completionHandlers {
                    comp()
                }
                self.refreshing = false
                completionHandler()
            }
        }
    }

    // MARK: Refresh
    public func refresh() {
        refresh {
        }
    }
    public func refresh(completionHandler: @escaping () -> Void) {
        if refreshing {
            completionHandlers.append(completionHandler)
            return
        }
        refreshing = true
        if usuarioID != nil {
            fetchUsuario(fetchCampainhas: true, completionHandler: completionHandler)
        } else {
            fetchUserID { (answer) in
                switch answer {
                case .fail(let description):
                    fatalError(description)
                default:
                    self.fetchUsuario(fetchCampainhas: true, completionHandler: completionHandler)
                    return
                }
            }
        }
    }

    // MARK: Singleton Properties
    private init() {
        container = CKContainer.default()
        privateDB = container.privateCloudDatabase
        sharedDB = container.sharedCloudDatabase
        publicDB = container.publicCloudDatabase
        alertCloudKit()
    }

    class func shared() -> DataController {
        return sharedModelController
    }

    private static var sharedModelController: DataController = {
        let mController = DataController()
        return mController
    }()

    // MARK: CloudKit

    // MARK: Alerting iCloudCredentials
    private func alertCloudKit() {
        container.accountStatus { (status, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            if status == .noAccount {
                let alert = UIAlertController(title: "Faça o login no iCloud".localized(),
                message: "Esse aplicativo usa o iCloud Drive para manter seus dados seguros.".localized() +
                    "Para ativar, vá em ajustes, iCloud, e entre com seu Apple ID.".localized(), preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                if let topController = UIApplication.shared.keyWindow?.rootViewController {
                    if let presentedController = topController.presentedViewController {
                        presentedController.present(alert, animated: true)
                    }
                }
            }
        }
    }

    // MARK: Saving Object
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

    // MARK: Saving Objects
    private func saveData(database: CKDatabase) {
        var records: [CKRecord] = []
        for obj in recordsToSave {
            records.append(obj.record)
        }
        recordsToSave = []
        let operation: CKModifyRecordsOperation = CKModifyRecordsOperation(
            recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        database.add(operation)
    }

    // MARK: Deleting Object
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
    private func fetchUserID(completionHandler: @escaping (DataFetchAnswer) -> Void) {
        container.fetchUserRecordID { (userID, error) in
            self.usuarioID = userID
            if let error = error {
                completionHandler(.fail(description: error.localizedDescription))
                return
            }
            completionHandler(.successful(results: nil))
        }
    }

    private func fetch(recordType: String, completionHandler: @escaping (DataFetchAnswer) -> Void) {
        let predicate = NSPredicate(value: true)
        fetch(query: CKQuery(recordType: recordType, predicate: predicate), completionHandler: completionHandler)
    }

    private func fetch(query: CKQuery, completionHandler: @escaping (DataFetchAnswer) -> Void) {
        fetch(query: query, database: publicDB, completionHandler: completionHandler)
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

extension Campainha {
    fileprivate convenience init(dono: Usuario) {
        let record = CKRecord(recordType: Campainha.recordType)
        self.init(dono: dono, record: record)
    }
}

extension GrupoCampainha {
    fileprivate convenience init(campainha: Campainha) {
        let record = CKRecord(recordType: GrupoCampainha.recordType)
        self.init(campainha: campainha, record: record)
    }
}

extension Usuario {
    fileprivate convenience override init() {
        let record = CKRecord(recordType: Usuario.recordType)
        self.init(record: record)
        guard let usuarioID = DataController.shared().usuarioID else {
            fatalError("Não autenticado")
        }
        idUsuario.value = usuarioID.recordName
    }
}
