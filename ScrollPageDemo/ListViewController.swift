//
//  ListViewController.swift
//  ScrollPageDemo
//
//  Created by 洪德晟 on 2017/8/2.
//  Copyright © 2017年 洪德晟. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    var dataSource: [AnyObject]?
    var pageIndex = 0
    var buttonDataSource: [String]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        tableView?.reloadData()
    }

}

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if let data = dataSource {
            cell.textLabel?.text = data[indexPath.row] as? String
        }
        
        return cell
    }
    
}

extension ListViewController: UITableViewDelegate {
    
}
