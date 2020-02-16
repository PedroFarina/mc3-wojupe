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
        if let split = segue.destination as? UISplitViewController,
            let leftNav = split.viewControllers.first as? UINavigationController,
            let leftCont = leftNav.topViewController as? DoorbellSelectionTableViewController,
            let rightNav = split.viewControllers.last as? UINavigationController,
            let rightCont = rightNav.topViewController as? CampainhaViewController {
            rightCont.campainha = DataController.shared().getCampainhas.first
            leftCont.campainhaDelegate = rightCont
            rightCont.selectionTableView = leftCont
        }
    }
}
