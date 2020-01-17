//
//  DoorbellSelectionTableViewController.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 15/01/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class DoorbellSelectionTableViewController: UITableViewController {
    private weak var selectedCampainha: Campainha?
    private var data: [Campainha] = DataController.shared().getCampainhas

    public override func viewDidLoad() {
        tableView.tableFooterView = UIView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }

    public func refreshData() {
        data = DataController.shared().getCampainhas
        if !data.isEmpty {
            navigationItem.leftBarButtonItem = self.editButtonItem
            tableView.allowsSelection = true
        } else {
            navigationItem.leftBarButtonItem = nil
            tableView.allowsSelection = false
        }
        tableView.reloadData()
    }

    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.isEmpty ? 5 : data.count
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        if data.isEmpty {
            cell.textLabel?.text = "Exemplo de campainha".localized()
            cell.isUserInteractionEnabled = false
        } else {
            cell.textLabel?.text = data[indexPath.row].titulo.value
            cell.editingAccessoryType = .disclosureIndicator
        }

        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            editCampainha(data[indexPath.row])
        } else {
            selectedCampainha = data[indexPath.row]
            self.performSegue(withIdentifier: "campainhaSelected", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCampainha = nil
    }

    public override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {

        let delete = UIContextualAction(style: .destructive, title: "Excluir".localized()) { (_, _, success) in
            DispatchQueue.main.async {
                self.deleteCampainha(self.data[indexPath.row])
                success(true)
                self.tableView.isEditing = false
            }
        }

        let edit = UIContextualAction(style: .normal, title: "Editar".localized()) { (_, _, success) in
            DispatchQueue.main.async {
                self.editCampainha(self.data[indexPath.row])
                success(true)
                self.tableView.isEditing = false
            }
        }
        edit.backgroundColor = .systemOrange

        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        config.performsFirstActionWithFullSwipe = true
        return config
    }

    private func editCampainha(_ target: Campainha) {
        selectedCampainha = target
        self.performSegue(withIdentifier: "editCampainha", sender: self)
        selectedCampainha = nil
    }

    private func deleteCampainha(_ target: Campainha) {
        let message = "Você deseja excluir ".localized() +
            target.titulo.value +
            "? Essa ação não pode ser desfeita.".localized()
        let alert = UIAlertController(title: "Confirmação de deleção".localized(),
                                      message: message,
                                      preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "Sim".localized(), style: .destructive) { (_) in
            DataController.shared().removeCampainha(target: target)
            self.refreshData()
        }
        let noAction = UIAlertAction(title: "Não".localized(), style: .cancel, handler: nil)

        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true)
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let editCont = nav.topViewController as? EdicaoTableViewController {
            editCont.campainha = selectedCampainha
            editCont.cont = self
        } else if let selectCont = segue.destination as? CampainhaViewController {
            selectCont.campainha = selectedCampainha
        }
    }
}
