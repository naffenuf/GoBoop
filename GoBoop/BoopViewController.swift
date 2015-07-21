//
//  BoopViewController.swift
//  GoBoop
//
//  Created by Craig on 7/21/15.
//  Copyright (c) 2015 Internet and Media. All rights reserved.
//

import UIKit
import AVFoundation
import CoreGraphics


class BoopViewController: UIViewController {

    @IBOutlet weak var hotSpot: UIImageView!
    
    let tapRec = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        hotSpot.addGestureRecognizer(tapRec)
        tapRec.addTarget(self, action: "handleTap:")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
    println("Subviews Laid out")
        sizeHotspotToScreen()
    }
    
    func sizeHotspotToScreen() {
        // Replaces hotspot image with one resized to the screen size
        let screenRect = UIScreen.mainScreen().bounds
        println("Screen Rect = \(screenRect)")
        UIGraphicsBeginImageContextWithOptions(screenRect.size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
//        hotSpot.contentMode = UIViewContentMode.ScaleAspectFit
        hotSpot.layer.renderInContext(context)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        hotSpot.image = theImage
        println("Hotspot image size = \(hotSpot.image?.size)")
    }
    
    func handleTap(UIGestureRecognizer) {
        
        println("Tap------------------------------------------------")
        var thePoint: CGPoint = tapRec.locationInView(hotSpot)
        println("Tap Point = \(thePoint)")
        let success = hotSpot.image!.isPixelRed(thePoint)
        if success {
            println("boop")
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

