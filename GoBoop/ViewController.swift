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
    let ukePlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
 
    }
    
//    override func viewWillAppear(animated: Bool) {
//    }
    
    override func viewDidAppear(animated: Bool) {
        let screenCenterV = CGFloat(UIScreen.mainScreen().bounds.height / 2)
        let screenCenterH = UIScreen.mainScreen().bounds.width / 2
        let fingerCenterV = screenCenterV - (pointingFinger.bounds.height / 2)
        var fingerPoint: CGPoint = CGPointMake(UIScreen.mainScreen().bounds.width - 10.0, fingerCenterV)
        pointingFinger.frame = CGRectMake(100.0, 100.0, pointingFinger.bounds.width, pointingFinger.bounds.height)

        
        var imageArray: [UIImage] = []
        let image1 = UIImage(named: "NoseImage1")
        let image2 = UIImage(named: "NoseImage2")
        let image3 = UIImage(named: "NoseImage3")
        imageArray.append(image1!)
        imageArray.append(image2!)
        imageArray.append(image3!)
        noseAnimation.animationImages = imageArray
        noseAnimation.animationRepeatCount = 40
        noseAnimation.animationDuration = 0.2
        noseAnimation.startAnimating()
        var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "nextScreen", userInfo: nil, repeats: false)
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

