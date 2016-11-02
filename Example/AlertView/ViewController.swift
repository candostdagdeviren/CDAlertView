//
//  ViewController.swift
//  AlertView
//
//  Created by Candost Dagdeviren on 10/30/2016.
//  Copyright (c) 2016 Candost Dagdeviren. All rights reserved.
//

import UIKit
import AlertView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let alert = AlertView(title: "TITLE IS HERE", message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", type: .notification)
        let doneAction = AlertViewAction(title: "Done")
        alert.add(action: doneAction)
        alert.show(with: nil)
    }
}

