//
//  AlbumListViewController.swift
//  SchoolOfRock
//
//  Created by John Paul Manoza on 06/11/2018.
//  Copyright © 2018 topsi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AlbumListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SORModel.sharedInstance.getAlbums()
        SORModel.sharedInstance.albums$.asObservable().subscribe(onNext: { albums in
            self.tableView.reloadData()
        }).disposed(by: bag);

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AlbumListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SORModel.sharedInstance.albums$.value.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.cellIdentifier, for: indexPath) as! AlbumTableViewCell
        let album = SORModel.sharedInstance.albums$.value[indexPath.row];
        cell.textLabel?.text = album.albumName; cell.detailTextLabel?.text = album.albumRelease;
        return cell;
    }
}
