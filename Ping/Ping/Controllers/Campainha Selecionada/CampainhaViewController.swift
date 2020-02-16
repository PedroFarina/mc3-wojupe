//
//  ViewController.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 28/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import PDFKit

public class CampainhaViewController: UIViewController {
    public func campainhaSelected(_ campainha: Campainha) {
        self.campainha = campainha
        tableController?.campainha = campainha
        tableController?.tableView.reloadData()
        if let senhaSwitch = tableController?.senhaSwitch {
            let senha = campainha.grupo.value?.senha.value ?? ""
            if senhaSwitch.onOff.isOn {
                if senha.isEmpty {
                    senhaSwitch.onOff.isOn = false
                    tableController?.heightConstraint?.constant -= 44
                }
            } else {
                if !senha.isEmpty {
                    senhaSwitch.onOff.isOn = true
                    tableController?.heightConstraint?.constant += 44
                }
            }
        }
        guard imgQR != nil else {
            return
        }
        updateInfo()
        imgQR.image = QRCodeGenerator.qrImage(from: "http://18.221.163.6/?i=\(campainha.grupo.referenceValue?.recordID.recordName ?? "")")
    }

    public func campainhaDeleted(_ campainha: Campainha) {
        if campainha == self.campainha {
            self.campainha  = nil
            navigationItem.title = ""
            imgQR.image = QRCodeGenerator.qrImage(from: "placeholder")
            lblDescricao.text = ""
        }
    }

    public func campainhaChangedQR() {
        guard let campainha = campainha else {
            return
        }
        imgQR.image = QRCodeGenerator.qrImage(from: "http://18.221.163.6/?i=\(campainha.grupo.referenceValue?.recordID.recordName ?? "")")
    }

    var tableController: CampainhaPropertiesTableViewController?
    var selectionTableView: DoorbellSelectionTableViewController?

    @IBOutlet weak var optionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var lblDescricao: UILabel!
    @IBOutlet weak var imgQR: UIImageView!
    public var campainha: Campainha?

    override public func viewDidLoad() {
        super.viewDidLoad()
        if !CloudKitNotification.permitted {
            CloudKitNotification.askPermission()
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        guard let campainha = campainha, let grupo = campainha.grupo.referenceValue else {
            imgQR.image = QRCodeGenerator.qrImage(from: "placeholder")
            return
        }
        updateInfo()
        imgQR.image = QRCodeGenerator.qrImage(from: "http://18.221.163.6/?i=\(grupo.recordID.recordName)")
    }

    public func updateInfo() {
        guard let campainha = campainha else {
            return
        }
        navigationItem.title = campainha.titulo.value
        lblDescricao.text = campainha.descricao.value
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let viewE = nav.topViewController as? EdicaoTableViewController {
                viewE.campainha = self.campainha
                viewE.selected = self
                viewE.selection = selectionTableView
            } else if let viewH = nav.topViewController as? HistoricoTableViewController {
                viewH.campainha = self.campainha
            }
        } else if let tableController = segue.destination
            as? CampainhaPropertiesTableViewController {
            self.tableController = tableController
            tableController.campainha = self.campainha
            tableController.heightConstraint = optionsHeightConstraint
        }
    }

    @IBAction func shareTap(_ sender: UITapGestureRecognizer) {
        guard let btn = sender.view else {
            return
        }
        let objectsToShare: [Any] = [pageView.toPDF() as Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        activityVC.popoverPresentationController?.sourceView = btn
        self.present(activityVC, animated: true, completion: nil)
    }
}
