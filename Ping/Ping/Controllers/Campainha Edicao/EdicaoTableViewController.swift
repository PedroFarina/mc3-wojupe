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
    public weak var campainha: Campainha?
    public weak var selected: CampainhaViewController?
    public weak var selection: DoorbellSelectionTableViewController?

    public override func numberOfSections(in tableView: UITableView) -> Int {
        var sects = super.numberOfSections(in: tableView)
        if campainha == nil {
            sects -= 1
        }
        return sects
    }

    public override func viewWillAppear(_ animated: Bool) {
        guard let campainha = campainha else {
            navigationItem.title = "Criando nova campainha".localized()
            navigationItem.rightBarButtonItem?.title = "OK".localized()
            return
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
            guard let campainha = self.campainha else {
                return
            }
            DataController.shared().removeCampainha(target: campainha)
            self.dismiss(animated: true) {
                if let cont = self.selected?.navigationController?.viewControllers.first as? DoorbellSelectionTableViewController {
                    cont.refreshData()
                }
                _ = self.selected?.navigationController?.popViewController(animated: true)
            }
        }))

        return ale
    }()

    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveTap(_ sender: Any) {
        let newTitulo = (cellTitulo.txtText ?? "").isEmpty ? "Porta".localized() : cellTitulo.txtText ?? ""
        let newDescricao = cellDescricao.txtText
        if let campainha = campainha {
            DataController.shared().editarCampainha(target: campainha, newTitulo: newTitulo,
                                                    newSenha: nil, newDescricao: newDescricao, newUrl: nil)
            selected?.updateInfo()
        } else if let user = DataController.shared().getUsuario {
            _ = DataController.shared().createCampainha(dono: user, titulo: newTitulo, descricao: newDescricao ?? "")
            selection?.refreshData()
        }
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
