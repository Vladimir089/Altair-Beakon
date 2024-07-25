//
//  TabBarViewController.swift
//  Altair Beakon
//
//  Created by Владимир Кацап on 23.07.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
    }
    

  
    func settings() {
        
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 16
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.25
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.layer.shadowRadius = 4
        tabBar.layer.masksToBounds = false
        
        
        
        //tab1
        let tabOneVC = BalanceViewController()
        let balanceTabItem = UITabBarItem(title: "", image: .tab1.resize(targetSize: CGSize(width: 24, height: 24)), tag: 0)
        tabOneVC.tabBarItem = balanceTabItem
        
        
        
        tabBar.unselectedItemTintColor = UIColor(red: 237/255, green: 225/255, blue: 255/255, alpha: 1)
        tabBar.tintColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
        
        
        viewControllers = [tabOneVC]
    }

}




extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
