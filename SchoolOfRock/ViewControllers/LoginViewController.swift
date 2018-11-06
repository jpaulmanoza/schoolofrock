//
//  LoginViewController.swift
//  SchoolOfRock
//
//  Created by John Paul Manoza on 06/11/2018.
//  Copyright © 2018 topsi. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        SORModel.sharedInstance.token$.asObservable().subscribe(onNext: { (token) in
            if let _ = token {
                self.performSegue(withIdentifier: "toAlbumListViewController", sender: self);
            }
        }).disposed(by: bag);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapLogin(_ sender: Any) {
        if let link = URL(string: SORModel.sharedInstance.getAuthenticateUrl()) {
            UIApplication.shared.open(link)
        }
    }
}
