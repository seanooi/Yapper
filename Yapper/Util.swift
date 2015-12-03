//
//  Util.swift
//  CarousellChat
//
//  Created by Sean Ooi on 7/24/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

public class Util {
    
    /// Returns the current system version number
    public class func systemVersion() -> Float {
        let versionString = UIDevice.currentDevice().systemVersion as NSString
        
        return versionString.floatValue
    }
    
    public class var inputDateFormatter : NSDateFormatter {
        struct Static {
            static let instance: NSDateFormatter = {
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeZone = NSTimeZone.localTimeZone()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                return dateFormatter
                }()
        }
        return Static.instance
    }
    
    public class var outputDateFormatter : NSDateFormatter {
        struct Static {
            static let instance: NSDateFormatter = {
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeZone = NSTimeZone.localTimeZone()
                dateFormatter.dateFormat = "dd MMM HH:mm"
                return dateFormatter
                }()
        }
        return Static.instance
    }
}

extension UIColor {
    /**
    Creates a color from the given hex color code.
    If an invalid hex is given, default returned color is black color.
    
    - parameter hex: The hex code of the color to be created. (# sign is optional)
    - parameter alpha: The opacity of the color. Default value is 1
    
    - returns: The `UIColor` object
    */
    public class func colorWithHex(hex: String, alpha: CGFloat = 1) -> UIColor {
        if hex.characters.count > 7 ||
            hex.isEmpty ||
            (hex.characters.count == 7 && !hex.hasPrefix("#"))
        {
            return UIColor.blackColor()
        }
        
        var rgb: CUnsignedInt = 0
        let scanner = NSScanner(string: hex)
        
        if hex.hasPrefix("#") {
            // skip '#' character
            scanner.scanLocation = 1
        }
        
        scanner.scanHexInt(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
