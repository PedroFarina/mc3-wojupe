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
    public var campainha: Campainha!

    private lazy var alertRenew: UIAlertController = {
        let ale = UIAlertController(title: "Tem certeza disso?".localized(),
                                    message: "Esta ação invalidará a campainha atual e gerará uma nova.".localized(),
                                    preferredStyle: .alert)
        ale.addAction(UIAlertAction(title: "Não".localized(), style: .cancel, handler: nil))

        ale.addAction(UIAlertAction(title: "Sim".localized(), style: .destructive, handler: { (_) in
            self.campainha.renewURL()
        }))

        return ale
    }()
    private lazy var alertDelete: UIAlertController = {
        let ale = UIAlertController(title: "Tem certeza disso?".localized(),
                                    message: "Esta ação deletará a campainha permanentemente.".localized(),
                                    preferredStyle: .alert)
        ale.addAction(UIAlertAction(title: "Não".localized(), style: .cancel, handler: nil))

        ale.addAction(UIAlertAction(title: "Sim".localized(), style: .destructive, handler: { (_) in
            DataController.shared().removeCampainha(target: self.campainha)
        }))

        return ale
    }()

    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveTap(_ sender: Any) {
        let newTitulo = cellTitulo.txtText
        let newDescricao = cellDescricao.txtText
        DataController.shared().editCampainha(target: campainha, newTitulo: newTitulo,
                                                   newSenha: nil, newDescricao: newDescricao, newUrl: nil)
        self.dismiss(animated: true, completion: nil)
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 1 {
                self.present(alertDelete, animated: true)
            } else if indexPath.row == 2 {
                self.present(alertRenew, animated: true)
            }
        }
    }
}
