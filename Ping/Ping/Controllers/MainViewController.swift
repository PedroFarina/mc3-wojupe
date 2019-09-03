//
//  ViewController.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 28/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var imgQR: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imgQR.image = QRCodeGenerator.qrImage(from: "placeholder")
    }

}
