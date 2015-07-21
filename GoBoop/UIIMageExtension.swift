//
//  UIIMageExtension.swift
//  GoBoop
//
//  Created by Craig on 7/21/15.
//  Copyright (c) 2015 Internet and Media. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    func isPixelRed(pos: CGPoint) -> Bool {
        
        var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        println("Pixel Position = \(pos.x), \(pos.y)")
        
        var r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        var g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        var b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        var a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        println("r = \(r), g = \(g) b = \(b) a = \(a)")
        if b > 0 || r > 0 || a > 0 || g > 0 {
            return true
        } else {
            return false
        }
    }
}
