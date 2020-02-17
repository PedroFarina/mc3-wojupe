//
//  ProtecaoViewController.swift
//  PageController
//
//  Created by Julia Santos on 05/09/19.
//  Copyright © 2019 Julia Santos. All rights reserved.
//

import UIKit

class ProtecaoViewController: UIViewController {

    @IBOutlet weak var swSenha: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        swSenha.isOn = false
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { (_) in
            UIView.animate(withDuration: 0.8, animations: {
                self.swSenha.isOn = true
            })
        }
    }
}
