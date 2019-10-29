//
//  ViewController.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 28/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import PDFKit

class CampainhaViewController: UIViewController {

    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var lblDescricao: UILabel!
    @IBOutlet weak var imgQR: UIImageView!
    public var campainha: Campainha?

    override func viewDidLoad() {
        super.viewDidLoad()
        CloudKitNotification.askPermission()
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let campainha = campainha, let grupo = campainha.grupo.referenceValue else {
            fatalError("Não existe uma campainha!")
        }
        imgQR.image = QRCodeGenerator.qrImage(from: "http://18.221.163.6/?i=\(grupo.recordID.recordName)")
        navBar.title = campainha.titulo.value
        lblDescricao.text = campainha.descricao.value
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let viewE = nav.topViewController as? EdicaoTableViewController {

            viewE.campainha = self.campainha
            nav.modalPresentationStyle = .fullScreen
        } else if let tableController = segue.destination
            as? CampainhaPropertiesTableViewController {
            tableController.campainha = self.campainha
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
