//
//  CampainhaPropertiesTableViewController.swift
//  Ping
//
//  Created by Wolfgang Walder on 30/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class CampainhaPropertiesTableViewController: UITableViewController {
    private lazy var dataSource: CampainhaPropertiesTableViewDataSource = CampainhaPropertiesTableViewDataSource()
    private var tbHandler: CampainhaPropertiesTableViewDelegate = CampainhaPropertiesTableViewDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: SwitchTableViewCell.xib, bundle: nil),
                           forCellReuseIdentifier: SwitchTableViewCell.identifier)
        tableView.register(UINib(nibName: TextWithTitleTableViewCell.xib, bundle: nil),
                           forCellReuseIdentifier: TextWithTitleTableViewCell.identifier)
        tableView.dataSource = dataSource
        tableView.delegate = tbHandler
        tableView.tableFooterView = UIView()
    }

}
