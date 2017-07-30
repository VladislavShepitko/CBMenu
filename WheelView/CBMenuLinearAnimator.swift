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
    let HIDE_SEGMENTS_ANIMATION_DELAY = 0.1
    
    
    func destenationPositionForSegment(menu:CBMenu, at indexPath:NSIndexPath)->CGPoint{
        let direction:CGFloat = indexPath.item % 2 == 0 ? 1 : -1
        curOffset = direction > 0 ? CGPointMake(curOffset.x + xOffset, 0) : curOffset
/*        if direction > 0{
            curOffset = CGPointMake(curOffset.x + xOffset, 0)
        }*/
        return menu.origin + curOffset * direction
    }
    
    func showSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    {
        segment.transform = CGAffineTransformMakeTranslation(menu.origin.x, menu.origin.y)
        menu.backgroundView.addSubview(segment)
        
        UIView.animateWithDuration(SHOW_SEGMENTS_ANIMATION_DURATION, delay: SHOW_SEGMENTS_ANIMATION_DELAY * Double(indexPath.item), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction,.CurveEaseOut], animations: { () -> Void in
            let destenation = segment.destenationPosition
            segment.transform = CGAffineTransformMakeTranslation(destenation.x, destenation.y)
            //segment.alpha = 1
            }, completion: nil)
    }
    func hideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem){
        //print("hide \(indexPath.item) element in \(segment.destenationPosition)")
        
        UIView.animateWithDuration(0.2 * Double(indexPath.item), animations: { () -> Void in
            segment.transform = CGAffineTransformMakeTranslation(menu.origin.x, menu.origin.y)
            //segment.alpha = 0
            }){(_)in
                segment.removeFromSuperview()
        }
    }
    
    //MARK:- helper functions
    func pointOnCircle(origin:CGPoint, numberOfSegments:Int, angle:Double,index:Int,radius:Double) -> CGPoint {
        let x = origin.x  - CGFloat(sin(angle / Double(numberOfSegments) * Double(index)) * radius)
        let y = origin.y  - CGFloat(cos(angle / Double(numberOfSegments) * Double(index)) * radius)
        return CGPoint(x: x, y: y)
    }
    
}
