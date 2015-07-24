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
import QuartzCore


class BoopViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var hotSpot: UIImageView!
    var currentImage = 1
    let TOTAL_IMAGES = 10 // change this in the program when adding more images
    let tapRec = UITapGestureRecognizer()
    var boopPlayer: AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the boop player
        var error: NSError?
        let thePath: String = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("Boop2Sound.caf")
        let theURL: NSURL = NSURL(fileURLWithPath: thePath)!
        if error != nil {
            println(error)
        } else {
            boopPlayer = AVAudioPlayer(contentsOfURL: theURL, error: &error)
            boopPlayer.delegate = self
        }
        
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
        getHotSpot()
        sizeHotspotToScreen()
    }
    
    func getHotSpot() {
        var filename: String = "Cloofy"
        var imageNumber = String(currentImage)
        filename += imageNumber
        filename += "boop"
        filename += ".png"
        println("Hotspot: \(filename)")
        let newHotSpot = UIImage(named:filename)
        hotSpot.image = newHotSpot!
        //        filename = "Cloofy"
        //        filename += imageNumber
        //        filename += ".jpg"
        //        let newImage = UIImage(named: filename)
    }
    
    func sizeHotspotToScreen() {
        // Replaces hotspot image with one resized to the screen size
        
        let screenRect = UIScreen.mainScreen().bounds
        println("Screen Rect = \(screenRect)")
        
        UIGraphicsBeginImageContextWithOptions(screenRect.size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        hotSpot.contentMode = UIViewContentMode.ScaleAspectFit
        hotSpot.layer.renderInContext(context)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        println("The Image from Context size = \(theImage.size)")
        hotSpot.image = theImage
        println("Hotspot image size = \(hotSpot.image?.size)")
        // Now we write the hotspot image to a file, then retrieve it
        // Saving and reloading corrects the image so that isPixelRed UIImage extension works properly
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        println(documentsFolderPath)
        let filename = "/hotSpotTemp.png"
        let writePath = documentsFolderPath + filename
        let data: NSData = UIImagePNGRepresentation(hotSpot.image!)
        data.writeToFile(writePath, atomically: true)
        
        hotSpot.image = UIImage(contentsOfFile: writePath)
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        currentImage++
        if currentImage > TOTAL_IMAGES {
            currentImage = 1
        }
        if player == boopPlayer && flag {
            sizeHotspotToScreen()
            var filename = "Cloofy"
            var imageNumber = String(currentImage)
            filename += imageNumber
            filename += ".jpg"
            println("Begin: \(filename)")
            let newImage: UIImage? = UIImage(named: filename)
            hotSpot.hidden = true
            var finished = true
            UIView.transitionWithView(self.picture,
                duration: 0.4,
                options: UIViewAnimationOptions.TransitionFlipFromBottom,
                animations: { self.picture.image = newImage },
                completion: { finished in self.getHotSpot(); self.hotSpot.hidden = false })
        }
    }
    
    func handleTap(UIGestureRecognizer) {
        
        println("Tap------------------------------------------------")
        var thePoint: CGPoint = tapRec.locationInView(hotSpot)
        println("Tap Point = \(thePoint)")
        let success = hotSpot.image!.isPixelRed(thePoint)
        if success {
            boopPlayer.play()
        }
    }
}

