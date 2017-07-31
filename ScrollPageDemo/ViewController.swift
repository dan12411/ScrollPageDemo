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
//            let offset = scrollView.bounds.width * CGFloat(currentPage)
//            scrollView.contentOffset.x = offset
            lastPage = currentPage
        }
    }
    
    private func setButtonTitleColor() {
        self.indicatorBtns[self.lastPage].setTitleColor(UIColor.lightGray, for: UIControlState())
        self.indicatorBtns[self.currentPage].setTitleColor(UIColor.blue, for: UIControlState())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width * CGFloat(self.pageCount),
                                                 height: scrollView.bounds.size.height)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
//        loadScrollViewWithPage(page:0)
//        loadScrollViewWithPage(page:1)
        
        initializeViewControllers()
        setButtonTitleColor()
        
        self.addChildViewController(firstVC)
        self.scrollView.addSubview(firstVC.view)
        firstVC.willMove(toParentViewController: self)
        
        self.addChildViewController(secondVC)
        self.scrollView.addSubview(secondVC.view)
        secondVC.willMove(toParentViewController: self)
        
        firstVC.view.frame.origin = CGPoint.zero
        secondVC.view.frame.origin = CGPoint(x: scrollView.bounds.size.width, y: 0)
    }
    
    func initializeViewControllers() {
        firstVC = UIStoryboard.initializeViewController(FirstViewController.self)
        secondVC = UIStoryboard.initializeViewController(SecondViewController.self)
        viewControllers.append(firstVC)
        viewControllers.append(secondVC)
    }

    @IBAction func tapButtonAction(_ sender: UIButton) {
        currentPage = sender.tag - 1
        
        let offset = scrollView.bounds.width * CGFloat(currentPage)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.contentOffset.x = offset
        })
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func loadScrollViewWithPage(page:Int) {
        if page < 0 || page >= self.pageCount {
            return
        } else if self.pageDic[page] == nil {
            print("add page \(page)")
            
            let imageView = UIImageView(frame: CGRect(x: scrollView.bounds.size.width * CGFloat(page),
                                                      y: 0,
                                                      width: scrollView.bounds.size.width,
                                                      height: scrollView.bounds.size.height ))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "pic\(page)")
            scrollView.addSubview(imageView)
            pageDic[page] = imageView
        }
    }
    
    func removeScrollViewWithPage(page:Int) {
        if page < 0 || page >= pageCount {
            return
        } else if pageDic[page] != nil {
            print("remove page \(page)")
            pageDic[page]?.removeFromSuperview()
            pageDic[page] = nil
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) /
            pageWidth)) + 1
//        pageControl.currentPage = page
        currentPage = page
        print(page)
        
//        loadScrollViewWithPage(page: page - 1)
//        loadScrollViewWithPage(page: page)
//        loadScrollViewWithPage(page: page + 1)
//        
//        removeScrollViewWithPage(page: page - 2)
//        removeScrollViewWithPage(page: page + 2)
    }
    
}

