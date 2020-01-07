//
//  LoadViewController.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 04/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class LoadViewController: UIViewController {
    public override func viewDidLoad() {
        DataController.shared().refresh {
            self.performSegue(withIdentifier: "main", sender: self)
        }
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let viewC = nav.topViewController as? CampainhaViewController {

            if DataController.shared().getCampainhas.isEmpty {
                if let user = DataController.shared().getUsuario {
                    viewC.campainha = DataController.shared().createCampainha(
                        dono: user, titulo: "Sua campainha".localized(),
                        descricao: "Campainha Acessivel\nRespeite!".localized())
                }
            } else {
                viewC.campainha = DataController.shared().getCampainhas.first
            }
        }
    }
}
