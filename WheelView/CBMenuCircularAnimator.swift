//
//  CBMenuCircularAnimator.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@objc class CBMenuCircularAnimator: NSObject, CBMenuAnimatorDelegate {
    
    
    let xOffset:CGFloat = 25.0
    var currentXPosition:CGFloat = 0.0
    var pos:CGPoint = CGPointZero
    func destenationPositionForSegment(menu:CBMenu, at indexPath:NSIndexPath)->CGPoint{
        if indexPath.item % 2 == 0 {
            pos = CGPointMake(currentXPosition, menu.frame.height / 2)
        }else {
            pos = CGPointMake(-currentXPosition, menu.frame.height / 2)
        }
        currentXPosition += xOffset
        
        
        return pos
    }
    
    func showSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    {
        print("show \(indexPath.item) element in \(segment.destenationPosition)")
        menu.backgroundView.addSubview(segment)
        UIView.animateWithDuration(0.4 * Double(indexPath.item), animations: { () -> Void in
            segment.transform = CGAffineTransformMakeTranslation(segment.destenationPosition.x, segment.destenationPosition.y)
            segment.alpha = 1
        })
    }
    func hideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem){
        print("hide \(indexPath.item) element in \(segment.destenationPosition)")
    }
    
    //MARK:- helper functions
    func pointOnCircle(origin:CGPoint, numberOfSegments:Int, angle:Double,index:Int,radius:Double) -> CGPoint {
        let x = origin.x  - CGFloat(sin(angle / Double(numberOfSegments) * Double(index)) * radius)
        let y = origin.y  - CGFloat(cos(angle / Double(numberOfSegments) * Double(index)) * radius)
        return CGPoint(x: x, y: y)
    }
    
}
