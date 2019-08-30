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
    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveTap(_ sender: Any) {
        var newTitulo = cellTitulo.txtText
        var newDescricao = cellDescricao.txtText
        self.dismiss(animated: true, completion: nil)
    }
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 1 {
            let alerta = UIAlertController(title: "Tem certeza disso?",
                                           message: "A ação QR não pode ser desfeita.", preferredStyle: .alert)
            let sim = UIAlertAction(title: "Sim", style: .destructive) { (_) in
                self.deletaQR()
            }
            let nao = UIAlertAction(title: "Não", style: .cancel, handler: nil)
            alerta.addAction(sim)
            alerta.addAction(nao)
            self.present(alerta, animated: true)
        }
    }
    func deletaQR() {
        print("DeletaQR")
    }
}
