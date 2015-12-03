//
//  TextToolbar.swift
//  CarousellChat
//
//  Created by Sean Ooi on 7/28/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

protocol TextToolbarDelegate: class, NSObjectProtocol {
    func didSendMessage(message: String)
}

class TextToolbar: UIView, UITextViewDelegate {

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    weak var delegate: TextToolbarDelegate?
    var toolbarView: UIView!
    let padding: CGFloat = 10
    let defaultHeight: CGFloat = 43
    let maxNumberOfLines = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }

    override func intrinsicContentSize() -> CGSize {
        var maxHeight = CGFloat.max
        
        if numberOfLines() > maxNumberOfLines {
            maxHeight = messageTextView.frame.height
        }
        
        let fixedWidth = messageTextView.frame.width
        let newSize = messageTextView.sizeThatFits(CGSize(width: fixedWidth, height: maxHeight))
        var newFrame = messageTextView.frame
        newFrame.size = CGSize(width: fixedWidth, height: min(newSize.height + padding, maxHeight))
        messageTextView.frame = newFrame
        
        return messageTextView.frame.size
    }
    
    func loadXib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        toolbarView = UINib(nibName: "TextToolbar", bundle: bundle).instantiateWithOwner(self, options: nil)[0] as! UIView
        toolbarView.frame = bounds
        toolbarView.backgroundColor = .lightGrayColor()
        toolbarView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        messageTextView.delegate = self
        messageTextView.layoutManager.allowsNonContiguousLayout = false
        sendButton.enabled = false
        
        addSubview(toolbarView)
    }

    func setupToolbar() {
        messageTextView.layer.rasterizationScale = UIScreen.mainScreen().scale
        messageTextView.layer.shouldRasterize = true
        messageTextView.layer.cornerRadius = 5.0
        messageTextView.layer.borderWidth = 1.0
        messageTextView.layer.borderColor = UIColor(white: 0.0, alpha: 0.2).CGColor
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let myString = textView.text as NSString
        let newString = myString.stringByReplacingCharactersInRange(range, withString: text) as String
        
        if newString.isEmpty {
            sendButton.enabled = false
        }
        else {
            sendButton.enabled = true
        }
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        resizeTextView(textView)
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        textView.layoutIfNeeded()
        
        var caretRect = textView.caretRectForPosition((textView.selectedTextRange?.end)!)
        caretRect.size.height += textView.textContainerInset.bottom
        textView.scrollRectToVisible(caretRect, animated: false)
    }
    
    /**
    Resizes the textView
    
    - parameter textView: The textView to resize
    */
    func resizeTextView(textView: UITextView) {
        var maxHeight = CGFloat.max
        if numberOfLines() >= maxNumberOfLines {
            maxHeight = textView.frame.height
        }
        
        let fixedWidth = textView.frame.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: maxHeight))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: fixedWidth, height: min(newSize.height, maxHeight))
        textView.frame = newFrame
        
        frame.size.height = ceil(newFrame.size.height + padding)
        
        if Util.systemVersion() > 7 {
            for c in constraints {
                let constraint = c 
                if constraint.firstAttribute == NSLayoutAttribute.Height && constraint.firstItem as! NSObject == self {
                    constraint.constant = newFrame.size.height < defaultHeight ? defaultHeight : frame.size.height
                }
            }
        }
    }
    
    /**
    Calculates the number of lines in `messageTextView`
    
    - returns: The number of lines is `messageTextView`
    */
    func numberOfLines() -> Int {
        let layoutManager = messageTextView.layoutManager
        var lines = 0
        var idx = 0
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        
        var lineRange = NSRange()
        
        for lines = 0, idx = 0; idx < numberOfGlyphs; lines++ {
            layoutManager.lineFragmentRectForGlyphAtIndex(idx, effectiveRange: &lineRange)
            idx = NSMaxRange(lineRange)
        }
        
        return lines
    }
    
    // MARK: - IBActions
    
    @IBAction func sendMessage(sender: AnyObject) {
        let message = messageTextView.text
        delegate?.didSendMessage(message)
        
        messageTextView.text = ""
        sendButton.enabled = false
        resizeTextView(messageTextView)
    }
}
