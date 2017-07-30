//
//  CBMenuAnimator.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@objc protocol CBMenuAnimatorDelegate {
    
    func destenationPositionForSegment(menu:CBMenu, at indexPath:NSIndexPath)->CGPoint
        
    optional func willShowSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    optional func willHideSegment(menu:CBMenu,at indexPath:NSIndexPath, segment: CBMenuItem)
    
    optional func showSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    optional func hideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    
    
    optional func didShowSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    optional func didHideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    
    optional func allAnimationsDidFinishWhenHide(menu:CBMenu)
    optional func allAnimationsDidFinishWhenShow(menu:CBMenu)
    
    optional func animateBackgroundWhenHide(menu:CBMenu)
    optional func animateBackgroundWhenShow(menu:CBMenu)
    
    
}
extension CBMenuAnimatorDelegate {
    func showSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    {
        segment.transform = CGAffineTransformMakeTranslation(menu.origin.x, menu.origin.y)
        menu.backgroundView.addSubview(segment)
        
        UIView.animateWithDuration(0.2, delay: 0.2 * Double(indexPath.item), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction,.CurveEaseOut], animations: { () -> Void in
            let destenation = segment.destenationPosition
            segment.transform = CGAffineTransformMakeTranslation(destenation.x, destenation.y)
            segment.alpha = 1
            }, completion: nil)
    }
    func hideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    {
        //print("hide \(indexPath.item) element in \(segment.destenationPosition)")
        
        UIView.animateWithDuration(0.2, delay: 0.2 * Double(indexPath.item), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction, .CurveEaseOut ], animations: { () -> Void in
            segment.transform = CGAffineTransformMakeTranslation(menu.origin.x, menu.origin.y)
            segment.alpha = 0
            }, completion: {(_)in
                segment.removeFromSuperview()
        })

    }
}
