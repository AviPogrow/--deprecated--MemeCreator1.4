//
//  Functions.swift
//  MemeCreator
//
//  Created by new on 2/29/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import Foundation
import UIKit
import Dispatch

func afterDelay(seconds: Double, closure: () -> ()) {
  let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
  dispatch_after(when, dispatch_get_main_queue(), closure)
}

let applicationDocumentsDirectory: String = {
		let paths = NSSearchPathForDirectoriesInDomains(
			 .DocumentDirectory, .UserDomainMask, true)
	return paths[0]
  }()
  let FontHUD = UIFont(name:"comic andy", size: 62.0)!
let FontHUDBig = UIFont(name:"comic andy", size:120.0)!