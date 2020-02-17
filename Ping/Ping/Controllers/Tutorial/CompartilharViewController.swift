//
//  CompartilharViewController.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 11/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class CompartilharViewController: UIViewController {
    @IBAction func comecarTap(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: "firstTime")
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.modalPresentationStyle = .fullScreen
    }
}
