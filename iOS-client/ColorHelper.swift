//
//  ColorButton.swift
//  iOS-client
//
//  Created by Kamiel Klumpers on 08/02/2017.
//  Copyright © 2017 arnaudschloune. All rights reserved.
//

import UIKit;

class ColorHelper{
    open static let colors = [
                    "green": UIColor(netHex:0x8CFF45),
                    "blue": UIColor(netHex:0x5F58E8),
                    "red": UIColor(netHex:0xFF0000),
                    "yellow": UIColor(netHex:0xE8E226)]
}

/**
 * Source: http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
 */
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return NSString(format:"#%06x", rgb) as String
    }
}
