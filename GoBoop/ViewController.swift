//
//  ViewController.swift
//  GoBoop
//
//  Created by Craig on 7/21/15.
//  Copyright (c) 2015 Internet and Media. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var noseAnimation: UIImageView!
    @IBOutlet weak var pointingFinger: UIImageView!
    @IBOutlet weak var pointingFingerXConstraint: NSLayoutConstraint!
    @IBOutlet weak var blackView: UIView!
    var ukePlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        self.noseAnimation.hidden = true

        }
    
    
     override func viewWillAppear(animated: Bool) {
        var error: NSError?
        let thePath: String = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("CloofyTheBoopyDog.caf")
        let theURL: NSURL = NSURL(fileURLWithPath: thePath)!
        if error != nil {
            println(error)
        } else {
            ukePlayer = AVAudioPlayer(contentsOfURL: theURL, error: &error)
            ukePlayer.delegate = self
    }
}

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        if player == ukePlayer {
            blackView.hidden = false 
            nextScreen()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        ukePlayer.play()
        var imageArray: [UIImage] = []
        let image1 = UIImage(named: "NoseImage1")
        let image2 = UIImage(named: "NoseImage2")
        let image3 = UIImage(named: "NoseImage3")
        imageArray.append(image1!)
        imageArray.append(image2!)
        imageArray.append(image3!)
        
        var centerFingerConstraint = NSLayoutConstraint(item: pointingFinger, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
        var finalFingerConstraint = NSLayoutConstraint(item: pointingFinger, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 80.0)

        UIView.animateWithDuration(1.5, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.view.removeConstraint(self.pointingFingerXConstraint)
            self.view.addConstraint(centerFingerConstraint)
            self.view.layoutIfNeeded()
            }, completion: { bool in
                UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.view.removeConstraint(centerFingerConstraint)
                    self.view.addConstraint(finalFingerConstraint)
                    self.view.layoutIfNeeded()
                    self.noseAnimation.hidden = false
                    self.noseAnimation.animationImages = imageArray
                    self.noseAnimation.animationRepeatCount = 6
                    self.noseAnimation.animationDuration = 0.2
                    self.noseAnimation.startAnimating()
//                    var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "nextScreen", userInfo: nil, repeats: false)
                    }, completion: nil)
        })

        
        
    }
    
    func nextScreen() {
        self.performSegueWithIdentifier("boopViewSegue", sender: self)

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

