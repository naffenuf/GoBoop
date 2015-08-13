//
//  UIIMageExtension.swift
//  GoBoop
//
//  Created by Craig on 7/21/15.
//  Copyright (c) 2015 Internet and Media. All rights reserved.
//

import Foundation
import UIKit
import Foundation

extension UIImage {
    
    func createBorder() -> UIImage {
        // Create image contaxt
        UIGraphicsBeginImageContext(self.size)
        // Create a random color
        let red = CGFloat(arc4random() % 100) / 100.0
        let green = CGFloat(arc4random() % 100) / 100.0
        let blue = CGFloat(arc4random() % 100) / 100.0
        let randomColor: UIColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
//        randomColor.setStroke()
        averageColor().setStroke()
        // Get scale factor for border
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        let imageWidth = self.size.width
        let imageHeight = self.size.height
        var scaleFactor: CGFloat
        if  UIInterfaceOrientationIsLandscape(orientation) {
            scaleFactor = imageHeight / screenHeight
        } else {
            scaleFactor = imageWidth / screenWidth
        }
        self.drawAtPoint(CGPointZero)
        let path: UIBezierPath = UIBezierPath(rect: CGRectMake(0, 0, imageWidth, imageHeight))
        path.lineWidth = 8 * scaleFactor
        path.stroke()
        let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        return result
    }
    
    func averageColor() -> UIColor {
        
        let rgba = UnsafeMutablePointer<CUnsignedChar>.alloc(4)
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context: CGContextRef = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, info)
        
        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage)
        
        if rgba[3] > 0 {
            
            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
            let multiplier: CGFloat = alpha / 255.0
            
            return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
            
        } else {
            
            return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
        }
    }
    
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
