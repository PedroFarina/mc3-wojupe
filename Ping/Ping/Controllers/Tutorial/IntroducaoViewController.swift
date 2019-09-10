//
//  IntroducaoViewController.swift
//  PageController
//
//  Created by Julia Santos on 05/09/19.
//  Copyright © 2019 Julia Santos. All rights reserved.
//

import UIKit

class IntroducaoViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = QRCodeGenerator.qrImage(from: "placeholder")
    }
}
