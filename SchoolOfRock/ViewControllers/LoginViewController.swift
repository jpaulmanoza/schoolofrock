//
//  LoginViewController.swift
//  SchoolOfRock
//
//  Created by John Paul Manoza on 06/11/2018.
//  Copyright © 2018 topsi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let model = SORModel();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapLogin(_ sender: Any) {
        if let link = URL(string: self.model.getAuthenticateUrl()) {
            UIApplication.shared.open(link)
        }
    }

}
