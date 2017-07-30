//
//  CBMenuCircularAnimator.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@objc class CBMenuLinearAnimator: NSObject, CBMenuAnimatorDelegate {
    let xOffset:CGFloat = 40.0
    
    var curOffset:CGPoint = CGPointZero
    
    //MARK:- animation's parameters
    let SHOW_SEGMENTS_ANIMATION_DURATION = 0.4
    let HIDE_SEGMENTS_ANIMATION_DURATION = 0.4
    
    let SHOW_SEGMENTS_ANIMATION_DELAY = 0.0
    let HIDE_SEGMENTS_ANIMATION_DELAY = 0.0
    
    
    func destenationPositionForSegment(menu:CBMenu, at indexPath:NSIndexPath)->CGPoint{
        let direction:CGFloat = indexPath.item % 2 == 0 ? 1 : -1
        curOffset = direction > 0 ? CGPointMake(curOffset.x + xOffset, 0) : curOffset

        return menu.origin + curOffset * direction
    }
    /*
    func showSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    {
        segment.transform = CGAffineTransformMakeTranslation(menu.origin.x, menu.origin.y)
        menu.backgroundView.addSubview(segment)
        
        UIView.animateWithDuration(self.SHOW_SEGMENTS_ANIMATION_DURATION, delay: self.SHOW_SEGMENTS_ANIMATION_DELAY * Double(indexPath.item), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction,.CurveEaseOut], animations: { () -> Void in
            let destenation = segment.destenationPosition
            segment.transform = CGAffineTransformMakeTranslation(destenation.x, destenation.y)
            segment.alpha = 1
            }, completion: nil)
    }
    func hideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem){
        //print("hide \(indexPath.item) element in \(segment.destenationPosition)")
        
        UIView.animateWithDuration(self.HIDE_SEGMENTS_ANIMATION_DURATION, delay: self.HIDE_SEGMENTS_ANIMATION_DELAY * Double(indexPath.item), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction, .CurveEaseOut ], animations: { () -> Void in
            segment.transform = CGAffineTransformMakeTranslation(menu.origin.x, menu.origin.y)
            segment.alpha = 0
            }, completion: {(_)in
                segment.removeFromSuperview()
        })
    }
    */
    
}
