//
//  FlickrResultCell.swift
//  MemeCreator
//
//  Created by new on 3/23/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//
import Foundation
import UIKit

class FlickrResultCell: UITableViewCell {
	
	@IBOutlet weak var flickrImageView: UIImageView!
	@IBOutlet weak var flickrLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		let selectedView = UIView(frame: CGRect.zero)
		selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
		
		selectedBackgroundView = selectedView
	}


}
