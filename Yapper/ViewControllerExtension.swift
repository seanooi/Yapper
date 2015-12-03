//
//  ViewControllerExtension.swift
//  CarousellChat
//
//  Created by Sean Ooi on 7/28/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let currentChat = chats[indexPath.item] as [String: String]
        let message = currentChat["message"]
        let timestamp = currentChat["timestamp"]
        let dateObject = Util.inputDateFormatter.dateFromString(timestamp!)
        let dateString = Util.outputDateFormatter.stringFromDate(dateObject!)
        
        if currentChat["type"] == "b" {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(buyerCellIdentifier, forIndexPath: indexPath) as! BuyerCollectionViewCell
            cell.messageLabel?.text = message
            cell.dateLabel?.text = dateString
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(sellerCellIdentifier, forIndexPath: indexPath) as! SellerCollectionViewCell
            cell.profileImageView?.sd_setImageWithURL(NSURL(string: item["buyer_image_url"]!), placeholderImage: UIImage(named: "Placeholder"))
            cell.messageLabel?.text = message
            cell.dateLabel?.text = dateString
            
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.frame.width - (sectionInset * 2)
        let currentChat = chats[indexPath.item] as [String: String]
        let message = currentChat["message"]!
        let size = sizeForText(message, width: width)
        
        return CGSize(width: width, height: size.height + 40)
    }
}

extension ViewController: TextToolbarDelegate {
    func didSendMessage(message: String) {
        let date = Util.inputDateFormatter.stringFromDate(NSDate())
        
        chats.append([
            "timestamp": date,
            "message": message,
            "type": "b"
            ])
        
        collectionView.reloadSections(NSIndexSet(index: 0))
        scrollToBottomWithKeyboardEndHeight()
    }
}