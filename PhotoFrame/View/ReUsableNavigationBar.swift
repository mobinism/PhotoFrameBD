//
//  ReUsableNavigationBar.swift
//  PhotoFrame
//
//  Created by Creativeitem on 10/11/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
class ReUsableNavigationBar: UINavigationController {
    
    func customizedNavigationBar(title: String!){
        /*let backImage = UIImage(named: "back-icon")
         self.navigationController?.navigationBar.backIndicatorImage = backImage
         self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage*/
        
        navigationController?.navigationBar.shadowImage = UIImage() // this line makes the navigation bar borderless.
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        navigationController?.navigationBar.layer.shadowRadius = 4.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.1
        self.title = title
        
        // removes the back title from back button of navigation bar
        let barAppearace = UIBarButtonItem.appearance()
        barAppearace.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
    }
}
