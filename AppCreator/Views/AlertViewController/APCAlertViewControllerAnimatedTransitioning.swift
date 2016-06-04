//
//  APCAlertViewControllerAnimatedTransitioning.swift
//  AppCreator
//
//  Created by Andre Muis on 6/4/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCAlertViewControllerAnimatedTransitioning : NSObject, UIViewControllerAnimatedTransitioning
{
    let isPresenting : Bool
    let duration : NSTimeInterval
    
    init(isPresenting: Bool)
    {
        self.isPresenting = isPresenting
        self.duration = 0.5
        
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return self.duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        if self.isPresenting == true
        {
            self.animatePresentationWithTransitionContext(transitionContext)
        }
        else
        {
            self.animateDismissalWithTransitionContext(transitionContext)
        }
    }
    
    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning)
    {
        if let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let containerView = transitionContext.containerView()
        {
            presentedControllerView.frame = transitionContext.finalFrameForViewController(presentedController)
            presentedControllerView.center.y += containerView.bounds.size.height
            
            containerView.addSubview(presentedControllerView)
            
            UIView.animateWithDuration(self.duration,
                                       delay: 0.0,
                                       usingSpringWithDamping: 1.0,
                                       initialSpringVelocity: 0.0,
                                       options: .AllowUserInteraction,
                                       animations:
                {
                    presentedControllerView.center.y -= containerView.bounds.size.height
                },
                                       completion:
                {(completed: Bool) -> Void in
                    transitionContext.completeTransition(completed)
                })
        }
    }
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning)
    {
        if let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let containerView = transitionContext.containerView()
        {
            UIView.animateWithDuration(self.duration,
                                       delay: 0.0,
                                       usingSpringWithDamping: 1.0,
                                       initialSpringVelocity: 0.0,
                                       options: .AllowUserInteraction,
                                       animations:
                {
                    presentedControllerView.center.y += containerView.bounds.size.height
                },
                                       completion:
                {(completed: Bool) -> Void in
                    transitionContext.completeTransition(completed)
                })
        }
    }
}




















