//
//  ViewController.swift
//  TrackerRoute
//
//  Created by Rayen on 10.06.2021.
//

import UIKit

class MainViewController: UIViewController {

    var onMap: ((String) -> Void)?
    var onLogout: (() -> Void)?

    @IBAction func showMap(_ sender: Any) {
        onMap?("пример")
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onLogout?()
    }
}
