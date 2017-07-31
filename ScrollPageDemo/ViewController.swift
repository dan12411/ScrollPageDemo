//
//  ViewController.swift
//  ScrollPageDemo
//
//  Created by 洪德晟 on 2017/7/31.
//  Copyright © 2017年 洪德晟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var indicatorBtns: [UIButton]!
    
    var pageControl: UIPageControl!
    var pageDic = [Int:UIImageView]()
    var pageCount = 2
    
    var firstVC: FirstViewController!
    var secondVC: SecondViewController!
    var viewControllers = [UIViewController]()
    
    var lastPage = 0
    var currentPage: Int = 0 {
        didSet {
            setButtonTitleColor()
            lastPage = currentPage
        }
    }
    
    // For Download URLSession
    lazy var session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    private func setButtonTitleColor() {
        self.indicatorBtns[self.lastPage].setTitleColor(UIColor.darkGray, for: UIControlState())
        self.indicatorBtns[self.currentPage].setTitleColor(UIColor.blue, for: UIControlState())
    }
    
    private func getDataFrom(_ url: String, completionHandler: @escaping ([NewsItem])->Void){
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
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(self.pageCount),
                                                 height: scrollView.bounds.size.height)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        initializeViewControllers()
        setButtonTitleColor()
        
        self.addChildViewController(firstVC)
        self.scrollView.addSubview(firstVC.view)
        firstVC.willMove(toParentViewController: self)
        
        self.addChildViewController(secondVC)
        self.scrollView.addSubview(secondVC.view)
        secondVC.willMove(toParentViewController: self)
        
        firstVC.view.frame.origin = CGPoint.zero
        secondVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        
        getDataFrom("https://tw.news.yahoo.com/rss/movies") {  data in
            self.firstVC.objects = data
            DispatchQueue.main.async {
                self.firstVC.tableView.reloadData()
            }
        }
        getDataFrom("https://tw.news.yahoo.com/rss/society") { data in
            self.secondVC.objects = data
            DispatchQueue.main.async {
                self.secondVC.tableView.reloadData()
            }
        }
        
    }
    
    func initializeViewControllers() {
        firstVC = UIStoryboard.initializeViewController(FirstViewController.self)
        secondVC = UIStoryboard.initializeViewController(SecondViewController.self)
        viewControllers.append(firstVC)
        viewControllers.append(secondVC)
    }

    @IBAction func tapButtonAction(_ sender: UIButton) {
        currentPage = sender.tag - 1
        
        let offset = UIScreen.main.bounds.width * CGFloat(currentPage)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.contentOffset.x = offset
        })
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = UIScreen.main.bounds.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) /
            pageWidth)) + 1
        currentPage = page
    }
    
}

