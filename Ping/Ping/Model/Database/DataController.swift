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

    private static func errorHandler(error: CKError, description: String? = nil) {
        switch error.code {
        case .notAuthenticated:
            let alert = UIAlertController(
                title: "Faça o login no iCloud".localized(),
                message: "Esse aplicativo usa o iCloud Drive para manter seus dados seguros.".localized() + " " +
                "Para ativar, vá em ajustes, iCloud, e entre com seu Apple ID.".localized(), preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancelar".localized(), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Abrir Ajustes".localized(), style: .default, handler: { (_) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                if let presented = topController.presentedViewController {
                    presented.present(alert, animated: true)
                } else {
                    topController.present(alert, animated: true)
                }
            }
        case .networkUnavailable, .networkFailure:
            let alert = UIAlertController(
                title: "Não foi possível se comunicar com o servidor.".localized(),
                message: "Esse aplicativo depende de uma conexão de internet.".localized() + " " +
                "Cheque sua conexão e tente novamente.".localized(), preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                if let presented = topController.presentedViewController {
                    presented.present(alert, animated: true)
                } else {
                    topController.present(alert, animated: true)
                }
            }
        default:
            if let description = description {
                fatalError(description)
            } else {
                fatalError(error.localizedDescription)
            }
        }
    }

    private var completionHandlerDefault: (DataActionAnswer) -> Void = {
        (answer) in
        switch answer {
        case .fail(let error, let desc):
            errorHandler(error: error, description: desc)
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
    public func editarCampainha(
        target campainha: Campainha,
        newTitulo titulo: String?, newSenha senha: String?,
        newDescricao descricao: String?,
        newUrl url: String?) {
        var hasModifications: Bool = false

        //Vendo se alteraremos o titulo
        if let titulo = titulo, titulo != campainha.titulo {
            campainha.titulo.value = titulo
            hasModifications = true
        }
        //Vendo se alteramos a senha
        if let senha = senha, let grupo = campainha.grupo.value, senha != grupo.senha {
            grupo.senha.value = senha
            if let usuario = _usuario {
                recordsToSave.append(usuario)
            }
            recordsToSave.append(grupo)
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
            recordsToSave.append(campainha)
            saveData(database: publicDB)
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

        guard let usuario = _usuario else {
            fatalError("Não havia um dono para a campainha")
        }
        recordsToSave.append(contentsOf: [grupo, campainha, usuario])

        saveData(database: publicDB)

        return grupo
    }

    // MARK: Salvar grupo de campainha
    private func saveGrupoCampainha(grupo: GrupoCampainha) {
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
        let users = grupo.usuarios.references
        for user in users {
            user.grupos.removeAll()
        }
        saveModifications(obj: users)

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
        recordsToSave.append(usuario)
        saveData(database: publicDB)
        return usuario
    }

    // MARK: Salvar usuário
    public func saveUsuario(usuario: Usuario) {
        saveObject(database: publicDB, object: usuario, completionHandler: completionHandlerDefault)
    }

    // MARK: Editar usuário
    public func editarUsuario(target usuario: Usuario, idSubscription: String) {
        if usuario.idSubscription.value != idSubscription {
            usuario.idSubscription.value = idSubscription
            recordsToSave.append(usuario)
            saveData(database: publicDB)
        }
    }

    // MARK: Remover usuário
    public func removeUsuario(target usuario: Usuario, completionHandler: @escaping () -> Void) {
        CloudKitNotification.deleteSubscription(completionHandler: {
            self._usuario = nil
            self._campainhas = []
            self._gruposCampainhas = []
            self.deleteObject(database: self.publicDB, object: usuario) { (_) in
                completionHandler()
            }
        })
    }

    // MARK: Fetch Usuario
    private func fetchUsuario(fetchCampainhas: Bool, completionHandler: @escaping () -> Void) {
        if let userID = usuarioID {
            let predicate = NSPredicate(format: "idUsuario == %@", userID.recordName)
            let query = CKQuery(recordType: "Usuario", predicate: predicate)
            self.fetch(query: query, completionHandler: { (answer) in
                switch answer {
                case .fail(let error, _):
                    DataController.errorHandler(error: error)
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
        guard !usuario.campainhas.recordReferences.isEmpty else {
            for comp in self.completionHandlers {
                comp()
            }
            self.refreshing = false
            completionHandler()
            return
        }

        let predicate = NSPredicate(format: "%K IN %@", "recordID", usuario.campainhas.recordReferences)
        let query = CKQuery(recordType: Campainha.recordType, predicate: predicate)
        fetch(query: query, database: publicDB) { (answer) in
            switch answer {
            case .fail(let error, _):
                DataController.errorHandler(error: error)
            case .successful(let results):
                guard let results = results else {
                    fatalError("Não foi poossivel dar fetch nas Campainhas")
                }
                for result in results {
                    self._campainhas.append(Campainha(dono: usuario, record: result))
                }
                self.fetchGrupoCampainha(completionHandler: completionHandler)
            }
        }
    }

    private func fetchGrupoCampainha(completionHandler: @escaping () -> Void) {
        guard let usuario = _usuario else {
            fatalError("Não existe um usuario cadastrado")
        }

        guard !usuario.grupos.recordReferences.isEmpty else {
            for comp in self.completionHandlers {
                comp()
            }
            self.refreshing = false
            completionHandler()
            return
        }

        _gruposCampainhas = []
        let predicate = NSPredicate(format: "%K IN %@", "recordID", usuario.grupos.recordReferences)
        let query = CKQuery(recordType: GrupoCampainha.recordType, predicate: predicate)
        fetch(query: query, database: publicDB) { (answer) in
            switch answer {
            case .fail(let error, _):
                DataController.errorHandler(error: error)
            case .successful(let results):
                guard let results = results else {
                    fatalError("Não foi poossivel dar fetch nos grupos de campainhas")
                }
                for result in results {
                    if let reference = result["Campainha"] as? CKRecord.Reference,
                        let campainha = self.getEntityByID(reference.recordID) as? Campainha {
                        self._gruposCampainhas.append(GrupoCampainha(campainha: campainha, record: result))
                    }
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
                case .fail(let error, _):
                    DataController.errorHandler(error: error)
                default:
                    self.fetchUsuario(fetchCampainhas: true, completionHandler: completionHandler)
                    return
                }
            }
        }
    }

    // MARK: Save modifications
    public func saveModifications() {
        if let usuario = _usuario {
            recordsToSave.append(usuario)
        }
        recordsToSave.append(contentsOf: _campainhas)
        recordsToSave.append(contentsOf: _gruposCampainhas)
        saveData(database: publicDB)
    }

    // MARK: Save object
    public func saveModifications(obj: [EntityObject]) {
        recordsToSave.append(contentsOf: obj)
        saveData(database: publicDB)
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

    // MARK: Reseting badges
    public func resetBadges() {
        let resetOperation = CKModifyBadgeOperation(badgeValue: 0)
        container.add(resetOperation)
    }

    // MARK: Saving Object
    private func saveObject(database: CKDatabase, object: EntityObject,
                            completionHandler: @escaping ((DataActionAnswer) -> Void)) {
        database.save(object.record) { (_, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(.fail(error: error, description:
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
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(.fail(error: error, description:
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
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(.fail(error: error, description:
                        "Erro no Query da Cloud - Fetch: \(String(describing: error))"))
                }
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
        database.perform(query, inZoneWith: nil) { (results, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(.fail(error: error, description:
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
    fileprivate convenience init(_ confused: String? = nil) {
        let record = CKRecord(recordType: Usuario.recordType)
        self.init(record: record)
        guard let usuarioID = DataController.shared().usuarioID else {
            fatalError("Não autenticado")
        }
        idUsuario.value = usuarioID.recordName
    }
}
