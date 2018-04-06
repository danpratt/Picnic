//
//  ViewController.swift
//  Picnic
//
//  Created by Daniel Pratt on 4/6/18.
//  Copyright © 2018 Blau Magier. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // IBOutlets for basket top and bottom
    @IBOutlet weak var basketTop: UIImageView!
    @IBOutlet weak var basketBottom: UIImageView!
    
    // IBOutlets for Fabric top and bottom
    @IBOutlet weak var fabricTop: UIImageView!
    @IBOutlet weak var fabricBottom: UIImageView!
    
    // IBOutlets for the inside
    @IBOutlet weak var bug: UIImageView!
    
    // variables for squashing bug
    // isBugDead = true will stop animation
    var isBugDead = false
    var tap: UITapGestureRecognizer?
    
    // for sound
    var squishPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup tap gesture
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        view.addGestureRecognizer(tap!)
        
        // prepare sounds
        if let squishURL = Bundle.main.url(forResource: "squish", withExtension: "caf", subdirectory: "Sounds"){
            squishPlayer = try? AVAudioPlayer(contentsOf: squishURL)
            squishPlayer.prepareToPlay()
        } else {
            print("Unable to find file")
        }
        
        
        // animate basket opening when view loads
        UIView.animate(withDuration: 0.7, delay: 1.0, options: .curveEaseOut, animations: {
            var basketTopFrame = self.basketTop.frame
            basketTopFrame.origin.y -= basketTopFrame.size.height
            
            var basketBottomFrame = self.basketBottom.frame
            basketBottomFrame.origin.y += basketBottomFrame.size.height
            
            self.basketTop.frame = basketTopFrame
            self.basketBottom.frame = basketBottomFrame
        }) { (finished) in
            print("Basket doors opened!")
        }
        
        // animate fabric opening when view loads
        // starting just after the basket
        UIView.animate(withDuration: 1.0, delay: 1.2, options: .curveEaseOut, animations: {
            var fabricTopFrame = self.fabricTop.frame
            fabricTopFrame.origin.y -= fabricTopFrame.size.height
            
            var fabricBottomFrame = self.fabricBottom.frame
            fabricBottomFrame.origin.y += fabricBottomFrame.size.height
            
            self.fabricTop.frame = fabricTopFrame
            self.fabricBottom.frame = fabricBottomFrame
        }) { (finished) in
            print("Fabric opened!")
        }
        
        moveBugLeft()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Bug Animation Functions
    
    func moveBugLeft() {
        if isBugDead { return }
        
        UIView.animate(withDuration: 1.0, delay: 2.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.bug.center = CGPoint(x: 100, y: 200)
        }) { (finished) in
            print("Bug moved left!")
            self.faceBugRight()
        }
    }
    
    func faceBugRight() {
        if isBugDead { return }
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.bug.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (finished) in
            print("Bug faced right")
            self.moveBugRight()
        }
    }
    
    func moveBugRight() {
        if isBugDead { return }
        
        UIView.animate(withDuration: 1.0, delay: 2.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.bug.center = CGPoint(x: 250, y: 290)
        }) { (finished) in
            print("Bug moved right!")
            self.faceBugLeft()
        }
    }
    
    func faceBugLeft() {
        if isBugDead { return }
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.bug.transform = CGAffineTransform(rotationAngle: 0.0)
        }) { (finished) in
            print("Bug faced left!")
            self.moveBugLeft()
        }
    }
    
    // MARK: - Bug Squashing
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: bug.superview)
        if (bug.layer.presentation()?.frame.contains(tapLocation))! {
            print("Bug tapped!")
            // if the bug is already dead, we don't want to re-animate it
            // that would be scary!
            if isBugDead { return }
            
            // remove the gesture recognizer and set bug to dead
            view.removeGestureRecognizer(tap!)
            isBugDead = true
            
            // play sound
            squishPlayer.play()
            
            UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseOut, animations: {
                self.bug.transform = CGAffineTransform(scaleX: 1.25, y: 0.75)
            }) { (finished) in
                UIView.animate(withDuration: 2.0, delay: 2.0, animations: {
                    self.bug.alpha = 0.0
                }, completion: { (finished) in
                    self.bug.removeFromSuperview()
                })
            }
            
        } else {
            print("Bug not tapped!")
        }
    }

}

