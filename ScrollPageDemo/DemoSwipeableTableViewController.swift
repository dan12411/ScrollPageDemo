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
    
    let titleBarDataSource = ["Movies", "Society", "Health"]
    
    var viewControllerDataSourceCollection = [["Delhi", "Gurgaon", "Noida"], ["Mumbai", "Bandra", "Andheri", "Dadar"], ["Banglore", "Kormangala", "Marathalli"]]
    
    var firstVC: ListViewController!
    var secondVC: ListViewController!
    var thirdVC: ListViewController!
    
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
            firstVC = ListViewController()
            getDataFrom("https://tw.news.yahoo.com/rss/movies") {  data in
                self.firstVC.dataSource = data
                DispatchQueue.main.async {
                    self.firstVC.mainTableView.reloadData()
                }
            }
            return firstVC
        case 1:
            secondVC = ListViewController()
            getDataFrom("https://tw.news.yahoo.com/rss/society") {  data in
                self.secondVC.dataSource = data
                DispatchQueue.main.async {
                    self.secondVC.mainTableView.reloadData()
                }
            }
            return secondVC
        case 2:
            thirdVC = ListViewController()
            getDataFrom("https://tw.news.yahoo.com/rss/health") {  data in
                self.thirdVC.dataSource = data
                DispatchQueue.main.async {
                    self.thirdVC.mainTableView.reloadData()
                }
            }
            return thirdVC
        default:
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.green
            return vc
        }
    }
}
