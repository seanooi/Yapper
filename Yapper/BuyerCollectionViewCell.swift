//
//  BuyerCollectionViewCell.swift
//  CarousellChat
//
//  Created by Sean Ooi on 7/29/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

class BuyerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var bubbleImageView: UIImageView?
    
    var bubbleImage: UIImage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        bubbleImage = UIImage(named: "BuyerBubble")?.resizableImageWithCapInsets(UIEdgeInsets(top: 10, left: 10, bottom: 38, right: 25), resizingMode: .Stretch)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bubbleImageView?.image = bubbleImage
        
        dateLabel?.font = UIFont.systemFontOfSize(8)
        messageLabel?.font = UIFont.systemFontOfSize(12)
        messageLabel?.numberOfLines = 0
    }
}
