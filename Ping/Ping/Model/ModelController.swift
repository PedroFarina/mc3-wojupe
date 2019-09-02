//
//  ModelController.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 30/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CoreData
import UIKit

public class ModelController {
    // MARK: Acessores de campainhas

    // MARK: Criar campainha
    public func createCampainha(titulo: String, descricao: String, url: String) -> ModelActionAnswer {
        guard
            let campainhaNova = NSEntityDescription.insertNewObject(forEntityName: "Campainha",
                into: context) as? Campainha
            else {
                return .fail(description: "Não foi possível criar uma campainha.".localized())
        }
        campainhaNova.titulo = titulo
        campainhaNova.descricao = descricao
        campainhaNova.url = url
        do {
            try _saveContext()
        } catch {
            return .fail(description: "Não foi possível salvar uma campainha.".localized())
        }
        return .successful
    }

    // MARK: Editar campainha
    public func editCampainha(target campainha: Campainha, newTitulo titulo: String?,
                              newDescricao descricao: String?, newUrl url: String?) -> ModelActionAnswer {
        var hasModifications: Bool = false

        //Vendo se alteraremos o titulo
        if let titulo = titulo, titulo != campainha.titulo {
            campainha.titulo = titulo
            hasModifications = true
        }
        //Vendo se alteraremos a descricao
        if let descricao = descricao, descricao != campainha.descricao {
            campainha.descricao = descricao
            hasModifications = true
        }
        //Vendo se alteraremos a campainha
        if let url = url, url != campainha.url {
            campainha.url = url
            hasModifications = true
        }

        //Se algo foi alterado, salvamos
        if hasModifications {
            do {
                try _saveContext()
            } catch {
                return .fail(description: "Não foi possível salvar a edição da campainha.".localized())
            }
        }
        return .successful
    }

    // MARK: Remover campainha
    public func removeCampainha(target campainha: Campainha) -> ModelActionAnswer {
        context.delete(campainha)
        do {
            try _saveContext()
        } catch {
            return .fail(description: "Não foi possível deletar uma campainha.".localized())
        }
        return .successful
    }

    // MARK: Acessores de Usuario
    public func addUsuario() -> ModelActionAnswer {
        guard
            let usuario = NSEntityDescription.insertNewObject(forEntityName: "Usuario",
                                                                    into: context) as? Usuario
            else {
                return .fail(description: "Não foi possível criar um Usuario.".localized())
        }
        usuario.usuarioId = UUID()
        do {
            try _saveContext()
        } catch {
            return .fail(description: "Não foi possível salvar uma campainha.".localized())
        }
        return .successful
    }

    // MARK: Singleton Properties
    private init() {
    }

    class func shared() -> ModelController {
        return sharedModelController
    }

    private static var sharedModelController: ModelController = {
        let mController = ModelController()
        return mController
    }()

    //Acessor mais fácil do contexto
    private lazy var context: NSManagedObjectContext = persistentContainer.viewContext

    //Criando container de persistencia
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Ping")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not
                // use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the
                 device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    //Funcão que verifica se houve mudanças no contexto e salva-as.
    public func saveContext () {
        if context.hasChanges {
            do {
                try _saveContext()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private func _saveContext() throws {
        try context.save()
    }
}
