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
    var introBoopPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Make audio player override mute switch since audio is critical to experience
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        // Animation for launch screen - hand comes out, touches nose, plays boop sound
        self.noseAnimation.hidden = true
        self.setNeedsStatusBarAppearanceUpdate()
        // Load a boop player for end of animation
        var error: NSError?
        let thePath: String = NSBundle.mainBundle().resourcePath!
        let theURL: NSURL = NSURL(fileURLWithPath: thePath).URLByAppendingPathComponent("Boop2.caf")
        if error != nil {
            print(error)
        } else {
            do {
                introBoopPlayer = try AVAudioPlayer(contentsOfURL: theURL)
            } catch var error1 as NSError {
                error = error1
                print(error1)
            }
            introBoopPlayer.prepareToPlay()
            introBoopPlayer.delegate = self
        }
    }
    
     override func viewWillAppear(animated: Bool) {
        // Play intro Ukulele
        var error: NSError?
        let thePath: String = NSBundle.mainBundle().resourcePath!
        let theURL: NSURL = NSURL(fileURLWithPath: thePath).URLByAppendingPathComponent("CloofyTheBoopyDog.caf")
        if error != nil {
            print(error)
        } else {
            do {
                ukePlayer = try AVAudioPlayer(contentsOfURL: theURL)
            } catch let error1 as NSError {
                error = error1
                print(error1)
            }
            ukePlayer.delegate = self
    }
}

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if player == ukePlayer {
                self.blackView.hidden = false
                self.nextScreen()  // proceed to game
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        ukePlayer.play()
        // png sequence animates around nose during boop sound
        var imageArray: [UIImage] = []
        let image1 = UIImage(named: "NoseImage1")
        let image2 = UIImage(named: "NoseImage2")
        let image3 = UIImage(named: "NoseImage3")
        imageArray.append(image1!)
        imageArray.append(image2!)
        imageArray.append(image3!)
        // Animate constraints of hand to touch Cloofy's nose
        let centerFingerConstraint = NSLayoutConstraint(item: pointingFinger, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
        let finalFingerConstraint = NSLayoutConstraint(item: pointingFinger, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 80.0)

        UIView.animateWithDuration(2.0, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
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
                    self.introBoopPlayer.play()
                    }, completion: {bool in
                        self.noseAnimation.hidden = true})
        })
    }
    
    func nextScreen() {
        self.performSegueWithIdentifier("boopViewSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

