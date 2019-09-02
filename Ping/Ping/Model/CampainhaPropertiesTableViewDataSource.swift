//
//  CampainhaPropertiesTableViewDataSource.swift
//  Ping
//
//  Created by Wolfgang Walder on 02/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class CampainhaPropertiesTableViewDataSource: NSObject, UITableViewDataSource {
    public var campainha: Campainha?

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var title: String = ""
        var exe: ((UISwitch) -> Void)?

        switch indexPath.row {
        case 0:
            title = "Proteção por Senha".localized()
            exe = {(swPassword) in
                let iPath: IndexPath = IndexPath(row: 1, section: 0)
                tableView.cellForRow(at: iPath)?.isHidden = !swPassword.isOn
                tableView.reloadRows(at: [iPath], with: .top)
            }
            fallthrough
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TextWithTitleTableViewCell.identifier)
                as? TextWithTitleTableViewCell {
                if let campainha = campainha {
                    cell.isHidden = campainha.senha == nil
                }
                cell.lblText = "Senha"
                cell.txtPlaceholder = "----"
                cell.maxCharacters = 4
                cell.completionCharacters = {(senha) in
                    if let campainha = self.campainha {
                        campainha.senha = senha
                    }
                }
                cell.txtField.keyboardType = .numberPad
                cell.txtField.textContentType = .newPassword
                cell.txtField.returnKeyType = .done
                return cell
            }
        case 2:
            title = "Modo Silencioso".localized()
            exe = {(swSilent) in
                if swSilent.isOn {
                    self.silenciar()
                } else {
                    self.desilenciar()
                }
            }
            fallthrough
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier)
                as? SwitchTableViewCell {
                cell.lblText = title
                cell.onOffChanged = exe
                return cell
            }
        }
        return UITableViewCell()
    }

    func silenciar() {

    }
    func desilenciar() {

    }
}
