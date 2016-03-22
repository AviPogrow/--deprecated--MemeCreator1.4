//
//  MyTabBarController.swift
//  MemeCreator
//
//  Created by new on 3/6/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
}

	override func childViewControllerForStatusBarStyle() -> UIViewController? {
		
		return nil 
}

}
