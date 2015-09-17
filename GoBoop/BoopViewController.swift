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
    let TOTAL_IMAGES = 20 // change this when adding more images
    let TOTAL_BOOP_SOUNDS = 18 // change this when adding more boop sound files
    var currentImage = 1
    let currentBoopSound = 1
    let tapRec = UITapGestureRecognizer()
    var boopPlayer: AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the boop player
        getRandomBoop()
        picture.image = picture.image!.createBorder()
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
        print("Subviews Laid out")
        getHotSpot()
        sizeHotspotToScreen()
    }
    
    func getHotSpot() {
        var filename: String = "Cloofy"
        let imageNumber = String(currentImage)
        filename += imageNumber
        filename += "boop"
        filename += ".png"
        print("Hotspot: \(filename)")
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
        print("Screen Rect = \(screenRect)")
        
        UIGraphicsBeginImageContextWithOptions(screenRect.size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        hotSpot.contentMode = UIViewContentMode.ScaleAspectFit
        hotSpot.layer.renderInContext(context!)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("The Image from Context size = \(theImage.size)")
        hotSpot.image = theImage
        print("Hotspot image size = \(hotSpot.image?.size)")
        // Now we write the hotspot image to a file, then retrieve it
        // Saving and reloading corrects the image so that isPixelRed UIImage extension works properly
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] 
        print(documentsFolderPath)
        let filename = "/hotSpotTemp.png"
        let writePath = documentsFolderPath + filename
        let data: NSData = UIImagePNGRepresentation(hotSpot.image!)!
        data.writeToFile(writePath, atomically: true)
        
        hotSpot.image = UIImage(contentsOfFile: writePath)
        
    }
    
    func getRandomBoop() {
        let rnd = (arc4random() % 17) + 1 // Change this when adding more boop sounds
        var filename = "Boop"
        let boopNumber = String(rnd)
        filename += boopNumber
        filename += ".caf"
        var error: NSError?
        let thePath: String = NSBundle.mainBundle().resourcePath!
        let theURL: NSURL = NSURL(fileURLWithPath: thePath).URLByAppendingPathComponent(filename)
        if error != nil {
            print(error)
        } else {
            do {
                boopPlayer = try AVAudioPlayer(contentsOfURL: theURL)
            } catch var error1 as NSError {
                error = error1
                print(error1)
            }
            boopPlayer.prepareToPlay()
            boopPlayer.delegate = self
        }
        
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        currentImage++
        if currentImage > TOTAL_IMAGES {
            currentImage = 1
        }
        if player == boopPlayer && flag {
            sizeHotspotToScreen()
            var filename = "Cloofy"
            let imageNumber = String(currentImage)
            filename += imageNumber
            filename += ".jpg"
            print("Begin: \(filename)")
            let newImage: UIImage? = UIImage(named: filename)
            hotSpot.hidden = true
//            var finished = true
            UIView.transitionWithView(self.picture,
                duration: 0.4,
                options: UIViewAnimationOptions.TransitionFlipFromBottom,
                animations: { self.picture.image = newImage; self.picture.image = self.picture.image?.createBorder() },
                completion: { finished in self.getHotSpot(); self.hotSpot.hidden = false; self.getRandomBoop() })
        }
    }
    
    func handleTap(_: UIGestureRecognizer) {
        
        print("Tap------------------------------------------------")
        let thePoint: CGPoint = tapRec.locationInView(hotSpot)
        print("Tap Point = \(thePoint)")
        let success = hotSpot.image!.isPixelRed(thePoint)
        if success {
            boopPlayer.play()
        }
    }
}

