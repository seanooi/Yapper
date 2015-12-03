//
//  ViewController.swift
//  Yapper
//
//  Created by Sean Ooi on 7/26/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let buyerCellIdentifier = "BuyerCell"
    let sellerCellIdentifier = "SellerCell"
    let sectionInset: CGFloat = 4
    let toolbarHeight: CGFloat = 43
    let saleItemHeight: CGFloat = 64
    
    var currentKeyboardHeight: CGFloat = 0
    var toolbar: TextToolbar!
    var saleItem: SaleItemView!
    var chats = [[String:  String]]()
    var item = [String: String]()
    
    // Activity indicator variables
    var activityIndicatorBox: UIView!
    var activityIndicator: UIActivityIndicatorView!
    var activityLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.translucent = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .Interactive
        collectionView.backgroundColor = .whiteColor()
        
        inputAccessoryView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        showIndicator()
        getChatData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override var inputAccessoryView: UIView {
        get {
            if toolbar == nil {
                let screenWidth = UIScreen.mainScreen().bounds.width
                toolbar = TextToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: toolbarHeight))
                toolbar.delegate = self
            }
            
            return toolbar
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo["UIKeyboardBoundsUserInfoKey"] as? NSValue)?.CGRectValue()
            currentKeyboardHeight = endFrame?.size.height ?? 0
            
            toggleSaleItemViewByKeyboardHeight()
            scrollToBottomWithKeyboardEndHeight()
        }
    }
    
    /**
    Retrieves the chat data
    */
    func getChatData() {
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET("http://www.seanooi.com/chat/content.json", parameters: nil, success: { (operation, responseObject) -> Void in
            if let response = responseObject as? [String: AnyObject] {
                if let responseChats = response["chats"] as? [[String: String]] {
                    self.chats = responseChats
                }
                
                if let responseItem = response["offer"] as? [String: String] {
                    self.item = responseItem
                    self.setupSaleItemView()
                }
                self.hideIndicator()
                self.collectionView.reloadSections(NSIndexSet(index: 0))
            }
            }, failure: { (operation, error) -> Void in
                print("Error: " + error.localizedDescription)
        })
    }
    
    /**
    Sets up the top sale item bar view
    */
    func setupSaleItemView() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        saleItem = SaleItemView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: saleItemHeight))
        saleItem.itemNameLabel?.text = item["product_name"]
        saleItem.itemPriceLabel?.text = item["product_price"]
        saleItem.itemImageView?.sd_setImageWithURL(NSURL(string: item["product_image_url"]!), placeholderImage: UIImage(named: "Placeholder"))
        saleItem.autoresizingMask = .FlexibleWidth
        
        title = item["buyer_name"]
        
        view.addSubview(saleItem)
    }
    
    /**
    Toggles the visibility of the top sale item bar view
    */
    func toggleSaleItemViewByKeyboardHeight() {
        if saleItem != nil {
            var toggleHide = CGAffineTransformIdentity
            
            if isShowingKeyboard() {
                toggleHide = CGAffineTransformMakeTranslation(0, -saleItemHeight)
            }
            
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                self.saleItem.transform = toggleHide
                }, completion: { (finish) -> Void in
                    //
            })
        }
    }
    
    /**
    Scrolls the chat to the latest (bottom) entry
    */
    func scrollToBottomWithKeyboardEndHeight() {
        let topInset = isShowingKeyboard() ? sectionInset : saleItemHeight
        
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: currentKeyboardHeight, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: currentKeyboardHeight, right: 0)
        
        // Don't scroll to bottom when dismissing keyboard
        if isShowingKeyboard() {
            collectionView.scrollEnabled = false
            collectionView.decelerationRate = UIScrollViewDecelerationRateFast
            
            if chats.count > 0 {
                let section = collectionView.numberOfSections() - 1
                let numberOfItems = chats.count - 1
                let indexPath = NSIndexPath(forItem: numberOfItems, inSection: section)
                collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
            }
            
            collectionView.scrollEnabled = true
            collectionView.decelerationRate = UIScrollViewDecelerationRateNormal
        }
        
        
    }
    
    /**
    Calculates the size of a given set of texts
    
    - parameter text:  The text to be used for calculating the size
    - parameter width: The maximum width the text should fit into
    
    - returns: The size of the box the given text can fit into
    */
    func sizeForText(text:String, width: CGFloat) -> CGSize {
        let temp = UILabel()
        temp.numberOfLines = 0
        temp.text = text
        
        let newSize = temp.sizeThatFits(CGSize(width: width, height: CGFloat.max))
        
        return newSize
    }
    
    /**
    Checks to see if keyboard is currently visible
    
    - returns: Boolean value whether keyboard is visible
    */
    func isShowingKeyboard() -> Bool {
        return currentKeyboardHeight > toolbarHeight
    }
    
    /**
    Shows an activity indicator
    */
    func showIndicator() {
        view.userInteractionEnabled = false
        inputAccessoryView.userInteractionEnabled = false
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        activityLabel = UILabel()
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        activityLabel.textColor = .whiteColor()
        activityLabel.text = "Loading Chat"
        activityLabel.adjustsFontSizeToFitWidth = true
        activityLabel.minimumScaleFactor = 0.5
        
        activityIndicatorBox = UIView()
        activityIndicatorBox.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorBox.backgroundColor = .blackColor()
        activityIndicatorBox.alpha = 0
        activityIndicatorBox.layer.cornerRadius = 8
        
        activityIndicatorBox.addSubview(activityIndicator)
        activityIndicatorBox.addSubview(activityLabel)
        view.addSubview(activityIndicatorBox)
        
        // Indicator constraints
        let indicatorLead =  NSLayoutConstraint(item: activityIndicator, attribute: .Leading, relatedBy: .Equal, toItem: activityIndicatorBox, attribute: .Leading, multiplier: 1, constant: 8)
        let indicatorCenterY = NSLayoutConstraint(item: activityIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: activityIndicatorBox, attribute: .CenterY, multiplier: 1, constant: 0)
        
        // Label constraints
        let labelLead = NSLayoutConstraint(item: activityLabel, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: activityIndicator, attribute: .Trailing, multiplier: 1, constant: 8)
        let labelCenterY = NSLayoutConstraint(item: activityLabel, attribute: .CenterY, relatedBy: .Equal, toItem: activityIndicatorBox, attribute: .CenterY, multiplier: 1, constant: 0)
        let labelTrail = NSLayoutConstraint(item: activityIndicatorBox, attribute: .Trailing, relatedBy: .Equal, toItem: activityLabel, attribute: .Trailing, multiplier: 1, constant: 8)
        
        // Box constraints
        let x = NSLayoutConstraint(item: activityIndicatorBox, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        let y = NSLayoutConstraint(item: activityIndicatorBox, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: -32)
        let w = NSLayoutConstraint(item: activityIndicatorBox, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 150)
        let h = NSLayoutConstraint(item: activityIndicatorBox, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50)
        
        activityIndicatorBox.addConstraint(indicatorLead)
        activityIndicatorBox.addConstraint(indicatorCenterY)
        activityIndicatorBox.addConstraint(labelLead)
        activityIndicatorBox.addConstraint(labelCenterY)
        activityIndicatorBox.addConstraint(labelTrail)
        
        view.addConstraint(x)
        view.addConstraint(y)
        view.addConstraint(w)
        view.addConstraint(h)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.activityIndicatorBox.alpha = 0.8
        })
    }
    
    /**
    Hides and removed the activity indicator
    */
    func hideIndicator() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.activityIndicatorBox.alpha = 0
            }) { (finish) -> Void in
                self.view.userInteractionEnabled = true
                self.inputAccessoryView.userInteractionEnabled = true
                
                self.activityIndicatorBox.removeFromSuperview()
                self.activityLabel = nil
                self.activityIndicator = nil
                self.activityIndicatorBox = nil
        }
    }

}
