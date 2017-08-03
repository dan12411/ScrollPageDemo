//
//  DemoSwipeableTableViewController.swift
//  ScrollPageDemo
//
//  Created by 洪德晟 on 2017/8/2.
//  Copyright © 2017年 洪德晟. All rights reserved.
//

import UIKit

class DemoSwipeableTableViewController: UIViewController {
    
    let swipeableView = SwipeableTableViewController()
    
    let titleBarDataSource = ["Movies", "Society", "Health","Movies", "Society", "Health"]
    
    var viewControllerDataSourceCollection = [["Delhi", "Gurgaon", "Noida"], ["Mumbai", "Bandra", "Andheri", "Dadar"], ["Banglore", "Kormangala", "Marathalli"]]
    
    // For Download URLSession
    lazy var session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    func getDataFrom(_ url: String, completionHandler: @escaping ([NewsItem])->Void){
        if let url = URL(string: url) {
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    // if error, return
                    return
                } else {
                    // if no error, analysis data
                    if let okData = data {
                        let xmlString = NSString(data: okData, encoding: String.Encoding.utf8.rawValue)
                        print(xmlString as Any)
                        let parser = XMLParser(data: okData)
                        let parseDelegate = RSSParseDelegate()
                        parser.delegate = parseDelegate
                        
                        if parser.parse() == true {
                            // if analysis ok
                            print("===Pasre ok!===")
                            completionHandler(parseDelegate.getResult())
                        } else {
                            print("===Fail!===")
                        }
                    }
                    
                }
            })
            task.resume()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        swipeableView.titleBarDataSource = titleBarDataSource
        swipeableView.delegate = self
        swipeableView.viewFrame = CGRect(x: 0.0, y: 64.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64.0)
        kSelectionBarSwipeConstant = CGFloat(titleBarDataSource.count)
        
        self.addChildViewController(swipeableView)
        self.view.addSubview(swipeableView.view)
        swipeableView.didMove(toParentViewController: self)
    }

}

extension DemoSwipeableTableViewController: SwipeableTableViewControllerDelegate{
    func didLoadViewControllerAtIndex(_ index: Int) -> UIViewController{
        switch index{
        case 0:
            let listVC = ListViewController()
            getDataFrom("https://tw.news.yahoo.com/rss/movies") {  data in
                listVC.dataSource = data as [AnyObject]
                DispatchQueue.main.async {
                    listVC.tableView.reloadData()
                }
            }
            return listVC
        case 1:
            let listVC = ListViewController()
            listVC.dataSource = viewControllerDataSourceCollection[index] as [AnyObject]?
            return listVC
        case 2:
            let listVC = ListViewController()
            listVC.dataSource = viewControllerDataSourceCollection[index] as [AnyObject]?
            return listVC
        default:
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.green
            return vc
        }
    }
}
