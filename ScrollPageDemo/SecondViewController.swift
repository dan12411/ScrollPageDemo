//
//  SecondViewController.swift
//  ScrollPageDemo
//
//  Created by 洪德晟 on 2017/7/31.
//  Copyright © 2017年 洪德晟. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var objects = [NewsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension SecondViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = objects[indexPath.row].title
        
        return cell
    }
    
}

extension SecondViewController: UITableViewDelegate {
    
}
