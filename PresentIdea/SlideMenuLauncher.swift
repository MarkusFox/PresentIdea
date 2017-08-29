//
//  SlideMenuLauncher.swift
//  PresentIdea
//
//  Created by Markus Fox on 28.08.17.
//  Copyright © 2017 Markus Fox. All rights reserved.
//

import UIKit

class SlideMenuLauncher: NSObject {
    let blackView = UIView()
    
    let slideView = SlideMenuTableViewController().view!
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    func showSlideMenu() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(slideView)
            
            let height: CGFloat = 200
            let y = window.frame.height - height
            
            slideView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            //EaseOut Curve
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.slideView.frame = CGRect(x: 0, y: y, width: self.slideView.frame.width, height: self.slideView.frame.height)
                
            }, completion: nil)
        }
        
        
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.slideView.frame = CGRect(x: 0, y: window.frame.height, width: self.slideView.frame.width, height: self.slideView.frame.height)
            }
        })
    }

    override init() {
        super.init()
    }
}
