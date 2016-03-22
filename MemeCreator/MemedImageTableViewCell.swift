//
//  MemedImageTableViewCell.swift
//  MemeCreator
//
//  Created by new on 2/28/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit

class MemedImageTableViewCell: UITableViewCell {

	@IBOutlet weak var memedImageView: UIImageView!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		
		backgroundColor = UIColor.blackColor()
		let selectionView = UIView(frame: CGRect.zero)
		selectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
		selectedBackgroundView = selectionView
    }

    

}
