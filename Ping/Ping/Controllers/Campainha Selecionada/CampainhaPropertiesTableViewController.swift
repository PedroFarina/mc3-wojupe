//
//  CampainhaPropertiesTableViewController.swift
//  Ping
//
//  Created by Wolfgang Walder on 30/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//
// swiftlint:disable function_body_length identifier_name

import UIKit
import Foundation

class CampainhaPropertiesTableViewController: UITableViewController {
    public var heightConstraint: NSLayoutConstraint?
    public var campainha: Campainha? {
        didSet {
            usuarios = campainha?.grupo.value?.usuarios.references
        }
    }
    private lazy var usuarios: [Usuario]? = campainha?.grupo.value?.usuarios.references
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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: SwitchTableViewCell.xib, bundle: nil),
                           forCellReuseIdentifier: SwitchTableViewCell.identifier)
        tableView.register(UINib(nibName: TextTableViewCell.xib, bundle: nil),
                           forCellReuseIdentifier: TextTableViewCell.identifier)
        tableView.register(UINib(nibName: TitleDetailDownDisclosureTableViewCell.xib, bundle: nil),
                           forCellReuseIdentifier: TitleDetailDownDisclosureTableViewCell.identifier)
        tableView.tableFooterView = UIView()

        tableView.allowsSelection = true
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TitleDetailDownDisclosureTableViewCell {
            cell.tap()
            if let usuarios = usuarios,
                let const = heightConstraint {
                closed = !closed
                var pathes: [IndexPath] = []
                for i in 3 ..< usuarios.count + 3 {
                    let index = IndexPath(row: i, section: 0)
                    tableView.cellForRow(at: index)?.isHidden = closed
                    pathes.append(index)
                }
                tableView.reloadRows(at: pathes, with: .bottom)
                const.constant += CGFloat(pathes.count * 44 * (closed ? -1 : 1))
            }
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }

    var closed: Bool = true
    var height: [CGFloat] = []
    var totalHeight: CGFloat {
        return height.reduce(0, +)
    }
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let amount: CGFloat
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isHidden {
                amount = 0
            } else {
                amount = 44
            }
        } else {
            if (!senhaEnabled && indexPath.row == 1) || (indexPath.row > 2 && closed) {
                amount = 0
            } else {
                amount = 44
            }
        }
        height[indexPath.row] = amount
        return amount
    }

    var firstLoad = true
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                                   forRowAt indexPath: IndexPath) {
        if firstLoad,
            let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                heightConstraint?.constant = totalHeight
                firstLoad = false
            }
        }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value: Int
        if let usuarios = usuarios {
            value = usuarios.count - 1 + 4
        } else {
            value = 4
        }
        height = Array(repeating: 0, count: value)
        return value
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                if let const = self.heightConstraint {
                    UIView.animate(withDuration: 1) {
                        const.constant += (swPassword.isOn ? 44 : -44)
                    }
                }
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
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                TitleDetailDownDisclosureTableViewCell.identifier)

                as? TitleDetailDownDisclosureTableViewCell {
                cell.titleText = "Compartilhada com".localized()
                cell.detailText = String((campainha?.grupo.value?.usuarios.references.count ?? 0) - 1) +
                    " pessoas".localized()
                return cell
            }
        case 3:
            let cell = UITableViewCell()
            cell.textLabel?.textColor = #colorLiteral(red: 0.2156862745, green: 0.5019607843, blue: 0.5607843137, alpha: 1)
            cell.textLabel?.text = "Adicionar pessoa"
            return cell
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}
