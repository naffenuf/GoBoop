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
    
    func createBorder() -> UIImage {
        // Create image context
        UIGraphicsBeginImageContext(self.size)
        let frameColor: UIColor = UIColor(red: 0.305, green: 0.58, blue: 0.992, alpha: 1.0)
        frameColor.setStroke()
        print("frame color = \(frameColor.description)")
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
    
    // The following function takes an average of all the colors in the Cloofy image
    // to use for the frame.  Left this in just in case, but the solid color looks better
    
//    func averageColor() -> UIColor {
//        
//        let rgba = UnsafeMutablePointer<CUnsignedChar>.alloc(4)
//        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
//        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue) as! UInt32
//        let context: CGContextRef = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, info)!
//        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage)
//        
//        if rgba[3] > 0 {
//            
//            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
//            let multiplier: CGFloat = alpha / 255.0
//            
//            return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
//            
//        } else {
//            
//            return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
//        }
//    }
    
    // Pixel test tapped position to see if it is over red color on the hotspot image.  
    func isPixelRed(pos: CGPoint) -> Bool {
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        print("Pixel Position = \(pos.x), \(pos.y)")
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        print("r = \(r), g = \(g) b = \(b) a = \(a)")
        if b > 0 || r > 0 || a > 0 || g > 0 {
            return true
        } else {
            return false
        }
    }
}
