//
//  MessageTableViewCell.swift
//  FlamingPants
//
//  Created by Maximilian Alexander on 7/24/15.
//  Copyright (c) 2015 Epoque. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    static let REUSE_ID = "MessageTableViewCell"
    
    let nameLabel : UILabel = UILabel()
    let bodyLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.font = UIFont.boldSystemFontOfSize(14.0)
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        bodyLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        bodyLabel.numberOfLines = 0
        
        self.addSubview(nameLabel)
        self.addSubview(bodyLabel)
        
        let views = ["nameLabel": nameLabel, "bodyLabel": bodyLabel]
        
        //Horizontal constraints
        let nameLabelHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[nameLabel]-10-|", options: nil, metrics: nil, views: views)
        let bodyLabelHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[bodyLabel]-10-|", options: nil, metrics: nil, views: views)
        self.addConstraints(nameLabelHorizontalConstraints)
        self.addConstraints(bodyLabelHorizontalConstraints)
        
        //Vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[nameLabel]-5-[bodyLabel]-10-|", options: nil, metrics: nil, views: views)
        self.addConstraints(verticalConstraints)
        

        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
