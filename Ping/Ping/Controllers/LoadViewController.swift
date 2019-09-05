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
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (_) in
            self.performSegue(withIdentifier: "main", sender: self)
        }
//        DataController.shared().refresh {
//            self.performSegue(withIdentifier: "main", sender: self)
//        }
    }
}
