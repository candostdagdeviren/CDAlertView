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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CDAlertViewType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let alertViewType = CDAlertViewType.allCases[indexPath.row]
        
        cell.textLabel?.text = alertViewType.description
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertViewType = CDAlertViewType.allCases[indexPath.row]
        
        let alert = CDAlertView(title: alertViewType.description, message: "Example message", type: alertViewType)
        let action = CDAlertViewAction(title: "DONE")
        alert.isTextFieldHidden = false
        alert.add(action: action)
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }

        alert.show() { (alert) in
            print("completed")
        }
    }
}

extension CDAlertViewType : CaseIterable
{
    public static var allCases: [CDAlertViewType] {
        return [.error, .warning, .success, .notification, .alarm, .noImage, .custom(image: UIImage())]
    }
  
    var description: String {
        switch self {
        case .error:
            return "Error"
        case .success:
            return "Success"
        case .warning:
            return "Warning"
        case .notification:
            return "Notification"
        case .alarm:
            return "Alarm"
        case .custom:
            return "Custom"
        case .noImage:
            return "No image"
        }
    }
}
