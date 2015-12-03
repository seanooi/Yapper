//
//  SaleItemView.swift
//  CarousellChat
//
//  Created by Sean Ooi on 7/29/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

class SaleItemView: UIView {

    @IBOutlet weak var itemImageView: UIImageView?
    @IBOutlet weak var itemNameLabel: UILabel?
    @IBOutlet weak var itemPriceLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let saleItemView = UINib(nibName: "SaleItemView", bundle: bundle).instantiateWithOwner(self, options: nil)[0] as! UIView
        saleItemView.frame = bounds
        saleItemView.backgroundColor = .lightGrayColor()
        saleItemView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2
        
        itemNameLabel?.font = UIFont.systemFontOfSize(14)
        itemNameLabel?.numberOfLines = 2
        itemNameLabel?.adjustsFontSizeToFitWidth = true
        itemNameLabel?.minimumScaleFactor = 0.5
        
        itemPriceLabel?.font = UIFont.systemFontOfSize(14)
        itemPriceLabel?.textColor = .redColor()
        
        addSubview(saleItemView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
