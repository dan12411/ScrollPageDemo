//
//  ListViewController.swift
//  ScrollPageDemo
//
//  Created by 洪德晟 on 2017/8/2.
//  Copyright © 2017年 洪德晟. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    var dataSource: [NewsItem]?
    var pageIndex = 0
    var buttonDataSource: [String]?
    
    var mainTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        self.view.addSubview(mainTableView)
        mainTableView.reloadData()
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
            cell.textLabel?.text = data[indexPath.row].title
        }
        
        return cell
    }
    
}

extension ListViewController: UITableViewDelegate {
    
}
