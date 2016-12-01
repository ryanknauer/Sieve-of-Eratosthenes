//
//  numberCell.swift
//  Sieve of Eratosthenes Application
//
//  Created by Ryan Knauer on 11/24/16.
//  Copyright © 2016 RyanKnauer. All rights reserved.
//

import UIKit
import Foundation

class NumberCell: UICollectionViewCell {
    let label = UILabel()
    var prime = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        label.text = "00"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        self.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
