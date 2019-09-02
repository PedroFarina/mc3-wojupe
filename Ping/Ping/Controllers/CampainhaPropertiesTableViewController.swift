//
//  CampainhaPropertiesTableViewController.swift
//  Ping
//
//  Created by Wolfgang Walder on 30/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class CampainhaPropertiesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: SwitchTableViewCell.xib, bundle: nil),
                           forCellReuseIdentifier: SwitchTableViewCell.identifier)

        tableView.register(UINib(nibName: TextWithTitleTableViewCell.xib, bundle: nil),
                           forCellReuseIdentifier: TextWithTitleTableViewCell.identifier)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "switch", for: indexPath)
            as? SwitchTableViewCell else {
            return UITableViewCell()
        }

        if indexPath.row == 0 {
            cell.lblTitle.text = "Proteção por senha"
        } else {
            cell.lblTitle.text = "Modo silencioso"
        }

        // Configure the cell...

        return cell
    }

}
