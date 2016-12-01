

//
//  slideAnimationExtension.swift
//  Sieve of Eratosthenes Application
//
//  Created by Ryan Knauer on 11/28/16.
//  Copyright © 2016 RyanKnauer. All rights reserved.
//

import Foundation
import UIKit

let slideIOAnimationDuration = 0.5

extension UIViewController{
    
    
    enum screenSide{
        case left
        case right
        case top
        case bottom
    }
    
    func slideInAnimation(animator: UIView, inFrom: screenSide, slideOut: Bool){
        var slideAnimation: CABasicAnimation
        var from : CGFloat
        var to : CGFloat
        let resetOrigin = animator.frame.origin
        
        
        CATransaction.commit()
        CATransaction.setCompletionBlock({
            animator.hidden = slideOut
            animator.frame.origin = resetOrigin
        })
        
        
        switch inFrom{
        case .top:
            slideAnimation = CABasicAnimation(keyPath: "position.y")
            from = 0 - (animator.frame.width / 2)
            to = animator.layer.position.y
        case .bottom:
            slideAnimation = CABasicAnimation(keyPath: "position.y")
            from = self.view.frame.height + (animator.frame.height / 2)
            to = animator.layer.position.y
        case .left:
            slideAnimation = CABasicAnimation(keyPath: "position.x")
            from = 0 - (animator.frame.width / 2)
            to = animator.layer.position.x
        case .right:
            slideAnimation = CABasicAnimation(keyPath: "position.x")
            from = self.view.frame.width + (animator.frame.width / 2)
            to = animator.layer.position.x
        }
        
        
        slideAnimation.duration = slideIOAnimationDuration
        if slideOut{
            slideAnimation.fromValue = Int(to)
            slideAnimation.toValue = Int(from)
        } else{
            slideAnimation.fromValue = Int(from)
            slideAnimation.toValue = Int(to)
        }
        
        slideAnimation.removedOnCompletion = true
        slideAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        
        
        animator.layer.addAnimation(slideAnimation, forKey: nil)
        CATransaction.begin()
        animator.hidden = false
        if slideOut{
            switch inFrom{
            case .top, .bottom:
                animator.layer.position.y = from
            case .right, .left:
                animator.layer.position.x = from
            }
        }

    }
    
}