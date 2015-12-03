//
//  SellerCollectionViewCell.swift
//  CarousellChat
//
//  Created by Sean Ooi on 7/29/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

class SellerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var profileImageView: UIImageView?
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
        bubbleImage = UIImage(named: "SellerBubble")?.resizableImageWithCapInsets(UIEdgeInsets(top: 10, left: 25, bottom: 38, right: 10), resizingMode: .Stretch)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = profileImageView?.frame.width ?? 0
        profileImageView?.layer.cornerRadius = width / 2
        profileImageView?.layer.masksToBounds = true
        profileImageView?.backgroundColor = .blueColor()
        bubbleImageView?.image = bubbleImage
        
        dateLabel?.font = UIFont.systemFontOfSize(8)
        messageLabel?.font = UIFont.systemFontOfSize(12)
        messageLabel?.numberOfLines = 0
    }
}
