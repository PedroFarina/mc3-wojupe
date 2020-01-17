//
//  HistoricoTableViewController.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 17/01/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class HistoricoTableViewController: UITableViewController {
    public weak var campainha: Campainha?
    private var data: [Visitante] = []

    public override func viewDidLoad() {
        tableView.tableFooterView = UIView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        guard let campainha = campainha else {
            fatalError("Não havia uma campainha selecionada")
        }
        DataController.shared().getVisitors(of: campainha) { (visitantes) in
            self.data = visitantes
            self.tableView.reloadData()
        }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.isEmpty {
            return 1
        }
        return data.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !data.isEmpty,
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell") {

            cell.textLabel?.text = data[indexPath.row].name
            let dtf = DateFormatter()
            dtf.dateFormat = "dd/MM HH:mm"
            cell.detailTextLabel?.text = dtf.string(from: data[indexPath.row].date)
            return cell
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = "Você não teve visitantes ainda.".localized()
        return cell
    }

    @IBAction func doneTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
