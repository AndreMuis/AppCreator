//
//  APCAlertViewControllerPresentationController.swift
//  AppCreator
//
//  Created by Andre Muis on 6/4/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCAlertViewControllerPresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate
{
    var dimmingView : UIView
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController)
    {
        let dimmingView : UIView = UIView()
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        dimmingView.alpha = 0.0
        
        self.dimmingView = dimmingView

        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
        
    override func presentationTransitionWillBegin()
    {
        if let containerView = self.containerView,
            let presentedView = self.presentedView()
        {
            self.dimmingView.frame = containerView.bounds
            
            containerView.addSubview(self.dimmingView)
            containerView.addSubview(presentedView)
        
            if let transitionCoordinator = self.presentingViewController.transitionCoordinator()
            {
                transitionCoordinator.animateAlongsideTransition(
                    {(context: UIViewControllerTransitionCoordinatorContext) -> Void in
                        self.dimmingView.alpha = 1.0
                    },
                    completion: nil)
            }
        }
    }
    
    override func presentationTransitionDidEnd(completed: Bool)
    {
        if completed == false
        {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin()
    {
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        {
            transitionCoordinator.animateAlongsideTransition(
                {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                    self.dimmingView.alpha = 0.0
                },
                completion: nil)
        }
    }
    
    override func dismissalTransitionDidEnd(completed: Bool)
    {
        if completed == true
        {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect
    {
        var frame = CGRect()
        
        if let containerView = containerView
        {
            frame = CGRect(x: (containerView.bounds.size.width - 250.0) / 2.0,
                           y: (containerView.bounds.size.height - 200.0) / 2.0,
                           width: 250.0,
                           height: 200.0)
        }
        
        return frame
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator transitionCoordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: transitionCoordinator)
        
        if let containerView = self.containerView
        {
            transitionCoordinator.animateAlongsideTransition(
                {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                    self.dimmingView.frame = containerView.bounds
                },
                completion:nil)
        }
    }
}
















