//
//  EdicaoTableViewController.swift
//  Ping
//
//  Created by Julia Santos on 30/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class EdicaoTableViewController: UITableViewController {
    @IBOutlet weak var cellTitulo: TextTableViewCell!
    @IBOutlet weak var cellDescricao: TextViewTableViewCell!
    @IBOutlet weak var cellRenovarButton: ButtonTableViewCell!
    @IBOutlet weak var cellApagarButton: ButtonTableViewCell!
    public var campainha: Campainha?

    public override func viewWillAppear(_ animated: Bool) {
        guard let campainha = campainha else {
            fatalError("Campainha inexistente.")
        }
        cellTitulo.txtText = campainha.titulo.value
        cellDescricao.txtText = campainha.descricao.value
    }

    private lazy var alertRenew: UIAlertController = {
        let ale = UIAlertController(title: "Tem certeza disso?".localized(),
                                    message: "Esta ação invalidará a campainha atual e gerará uma nova.".localized(),
                                    preferredStyle: .alert)
        ale.addAction(UIAlertAction(title: "Não".localized(), style: .cancel, handler: nil))

        ale.addAction(UIAlertAction(title: "Sim".localized(), style: .destructive, handler: { (_) in
            self.campainha?.renewURL()
        }))

        return ale
    }()
    private lazy var alertDelete: UIAlertController = {
        guard let campainha = self.campainha else {
            fatalError("Campainha inexistente.")
        }
        let ale = UIAlertController(
            title: "Tem certeza disso?".localized(),
            message: "Esta ação deletará a campainha permanentemente e o app fechará.".localized(),
                                    preferredStyle: .alert)
        ale.addAction(UIAlertAction(title: "Não".localized(), style: .cancel, handler: nil))

        ale.addAction(UIAlertAction(title: "Sim".localized(), style: .destructive, handler: { (_) in
            guard let usuario = DataController.shared().getUsuario else {
                return
            }
            UserDefaults.standard.setValue(false, forKey: "firstTime")
            DataController.shared().removeUsuario(target: usuario, completionHandler: {
                exit(0)
            })
        }))

        return ale
    }()

    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveTap(_ sender: Any) {
        guard let campainha = self.campainha else {
            fatalError("Campainha inexistente.")
        }

        let newTitulo = cellTitulo.txtText
        let newDescricao = cellDescricao.txtText
        DataController.shared().editarCampainha(target: campainha, newTitulo: newTitulo,
                                                   newSenha: nil, newDescricao: newDescricao, newUrl: nil)
        self.dismiss(animated: true, completion: nil)
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                self.present(alertRenew, animated: true)
            } else if indexPath.row == 1 {
                self.present(alertDelete, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
