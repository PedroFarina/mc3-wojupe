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
    private var senhaEnabled: Bool = false {
        didSet {
            if !senhaEnabled {
                guard let campainha = self.campainha else {
                    return
                }
                DataController.shared().editarCampainha(target: campainha, newTitulo: nil,
                                                      newSenha: "", newDescricao: nil, newUrl: nil)
            }
        }
    }

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
                self.senhaEnabled = swPassword.isOn
                tableView.cellForRow(at: iPath)?.isHidden = !swPassword.isOn
                tableView.reloadRows(at: [iPath], with: .middle)
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier)
                as? SwitchTableViewCell {
                cell.lblText = title
                if let grupo = campainha?.grupo.value, let senha = grupo.senha.value {
                    cell.onOff.isOn = senha != "" || cell.onOff.isOn
                    senhaEnabled = cell.onOff.isOn
                }
                cell.onOffChanged = exe
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier)
                as? TextTableViewCell {
                cell.isHidden = !senhaEnabled
                if let grupo = campainha?.grupo.value {
                    cell.txtText = grupo.senha.value
                }
                cell.txtPlaceholder = "Password".localized()
                cell.accessibilityLabel = "Campo de senha da sua campainha.".localized()
                cell.accessibilityHint =
                "Este campo será exigido do visitante ao tentar tocar sua campainha.".localized()
                cell.maxCharacters = 4
                cell.completionCharacters = {(senha) in
                    cell.txtField.resignFirstResponder()
                    if let campainha = self.campainha {
                        DataController.shared().editarCampainha(
                        target: campainha, newTitulo: nil, newSenha: senha, newDescricao: nil, newUrl: nil)
                    }
                }
                cell.txtField.keyboardType = .numberPad
                cell.txtField.textContentType = .password
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier)
                as? SwitchTableViewCell {
                cell.isHidden = true
                cell.lblText = title
                cell.onOffChanged = exe
                return cell
            }
        default:
            fatalError("Erro no indice da CampainhaPropertiesTableView".localized())
        }
        return UITableViewCell()
    }

    func silenciar() {

    }
    func desilenciar() {

    }
}
