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
    
    var pageCount = 3
    
    var firstVC: FirstViewController!
    var secondVC: SecondViewController!
    var thirdVC: HealthViewController!
    var viewControllers = [UIViewController]()
    
    var lastPage = 0
    var currentPage: Int = 0 {
        didSet {
            setButtonTitleColor()
            lastPage = currentPage
        }
    }
    
    var currentOrientationIsPortrait : Bool = true
    
    // For Download URLSession
    lazy var session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    private func setUpScrollView() {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(self.pageCount), height: scrollView.bounds.size.height)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
    }
    
    private func initializeViewControllers() {
        firstVC = UIStoryboard.initializeViewController(FirstViewController.self)
        secondVC = UIStoryboard.initializeViewController(SecondViewController.self)
        thirdVC = UIStoryboard.initializeViewController(HealthViewController.self)
        viewControllers.append(firstVC)
        viewControllers.append(secondVC)
        viewControllers.append(thirdVC)
    }
    
    private func setButtonTitleColor() {
        self.indicatorBtns[self.lastPage].setTitleColor(UIColor.lightGray, for: UIControlState())
        self.indicatorBtns[self.currentPage].setTitleColor(UIColor.orange, for: UIControlState())
    }
    
    private func addViewControllersConstraints() {
        self.addChildViewController(firstVC)
        self.scrollView.addSubview(firstVC.view)
        firstVC.willMove(toParentViewController: self)
        
        self.addChildViewController(secondVC)
        self.scrollView.addSubview(secondVC.view)
        secondVC.willMove(toParentViewController: self)
        
        self.addChildViewController(thirdVC)
        self.scrollView.addSubview(thirdVC.view)
        thirdVC.willMove(toParentViewController: self)
        
        firstVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        secondVC.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        thirdVC.view.frame = CGRect(x: self.view.frame.width*CGFloat(2), y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
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
    
    private func getYahooData() {
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
        getDataFrom("https://tw.news.yahoo.com/rss/health") { data in
            self.thirdVC.objects = data
            DispatchQueue.main.async {
                self.thirdVC.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScrollView()
        initializeViewControllers()
        setButtonTitleColor()
        
        addViewControllersConstraints()
        getYahooData()
    }

    @IBAction func tapButtonAction(_ sender: UIButton) {
        currentPage = sender.tag - 1
        
        let offset = UIScreen.main.bounds.width * CGFloat(currentPage)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.contentOffset.x = offset
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Orientation Change
    
    override open func viewDidLayoutSubviews() {
        
        scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(self.pageCount), height: self.view.frame.height)
        
        let oldCurrentOrientationIsPortrait : Bool = currentOrientationIsPortrait
        
        if UIDevice.current.orientation != UIDeviceOrientation.unknown {
            currentOrientationIsPortrait = UIDevice.current.orientation.isPortrait || UIDevice.current.orientation.isFlat
        }
        
        if (oldCurrentOrientationIsPortrait && UIDevice.current.orientation.isLandscape) || (!oldCurrentOrientationIsPortrait && (UIDevice.current.orientation.isPortrait || UIDevice.current.orientation.isFlat)) {
            
            for view in scrollView.subviews {
                if view == firstVC.view {
                    view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
                if view == secondVC.view {
                    view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
                if view == thirdVC.view {
                    view.frame = CGRect(x: self.view.frame.width*CGFloat(2), y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
            
            let xOffset : CGFloat = CGFloat(self.currentPage) * scrollView.frame.width
            scrollView.setContentOffset(CGPoint(x: xOffset, y: scrollView.contentOffset.y), animated: false)
        }
        
        self.view.layoutIfNeeded()
    }
}

//MARK: - UIScrollViewDelegate

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = UIScreen.main.bounds.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) /
            pageWidth)) + 1
        guard page < pageCount && page > -1 else {
            return
        }
        currentPage = page
    }
    
}

