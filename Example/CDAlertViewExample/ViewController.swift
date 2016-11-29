//
//  ViewController.swift
//  CDAlertViewExample
//
//  Created by Candost Dagdeviren on 29/11/2016.
//  Copyright © 2016 Candost Dagdeviren. All rights reserved.
//

import UIKit
import CDAlertView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let alert = CDAlertView(title: "Title", message: "Message", type: .notification)
        let action = CDAlertViewAction(title: "DONE")
        alert.add(action: action)
        alert.show()
        
    }
}

