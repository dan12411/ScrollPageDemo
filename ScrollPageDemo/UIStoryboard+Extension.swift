//
//  UIStoryboard+Extension.swift
//  ScrollPageDemo
//
//  Created by 洪德晟 on 2017/7/31.
//  Copyright © 2017年 洪德晟. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func main() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func initializeViewController<T>(_ viewController: T.Type) -> T where T: UIViewController {
        return UIStoryboard.main().instantiateViewController(withIdentifier: String(describing: viewController)) as! T
    }
}
