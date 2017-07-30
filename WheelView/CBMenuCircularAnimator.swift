//
//  CBMenuCircularAnimator.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/30/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@objc class CBMenuCircularAnimator:NSObject, CBMenuAnimatorDelegate {
    /*
    lazy var radius:Double  = {
    print("self frame: \(self.frame)")
    //print("background frame: \(self.backgroundView.frame)")
    let d = Double((max(self.frame.width, self.frame.height) / 2.0 )) - Double(self.segmentSize.width)
    //print("asdasd \(d)")
    return d
    }()*/
    
    func destenationPositionForSegment(menu:CBMenu, at indexPath:NSIndexPath)->CGPoint{
        /*let direction:CGFloat = indexPath.item % 2 == 0 ? 1 : -1
        curOffset = direction > 0 ? CGPointMake(curOffset.x + xOffset, 0) : curOffset
        
        return menu.origin + curOffset * direction*/
        return CGPointZero
    }
    /*
    func showSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    {
        segment.transform = CGAffineTransformMakeTranslation(menu.origin.x, menu.origin.y)
        menu.backgroundView.addSubview(segment)
        
        //let angleForEachSection =  /*self.angle */ 90.radians
        
        //let startPoint = self.pointOnCircle(self.origin, numberOfSegments: self.segmentCount, angle: angleForEachSection, index: num, radius: self.radius)
    
        for (index,segment) in self.segments.enumerate() {
        //reset segment's origin point
        segment.transform = CGAffineTransformMakeTranslation(self.origin.x, self.origin.y)
        self.backgroundView.addSubview(segment)
        
        UIView.animateWithDuration(SHOW_SEGMENTS_ANIMATION_DURATION, delay: SHOW_SEGMENTS_ANIMATION_DELAY * Double(index), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction,.CurveEaseOut], animations: { () -> Void in
        let destenation = segment.destenationPosition
        segment.transform = CGAffineTransformMakeTranslation(destenation.x, destenation.y)
        segment.alpha = 1
        }, completion: nil)
        }
    }*/
/*
    func hideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem){
        //print("hide \(indexPath.item) element in \(segment.destenationPosition)")

        UIView.animateWithDuration(self.HIDE_SEGMENTS_ANIMATION_DURATION, delay: self.HIDE_SEGMENTS_ANIMATION_DELAY * Double(indexPath.item), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction, .CurveEaseOut ], animations: { () -> Void in
            segment.transform = CGAffineTransformMakeTranslation(menu.origin.x, menu.origin.y)
            segment.alpha = 0
            }, completion: {(_)in
                segment.removeFromSuperview()
        })
        
        
    
        UIView.animateWithDuration(0.1, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: { () -> Void in
        }) { (_) -> Void in
        for (index,segment) in self.segments.enumerate() {
        UIView.animateWithDuration(self.HIDE_SEGMENTS_ANIMATION_DURATION, delay: self.HIDE_SEGMENTS_ANIMATION_DELAY * Double(index), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction, .CurveEaseOut ], animations: { () -> Void in
        segment.transform = CGAffineTransformMakeTranslation(self.origin.x, self.origin.y)
        segment.alpha = 0
        }, completion: {(_)in
        segment.removeFromSuperview()
        })
        }
        }

    }*/
    
    //MARK:- helper functions
    func pointOnCircle(origin:CGPoint, numberOfSegments:Int, angle:Double,index:Int,radius:Double) -> CGPoint {
        let x = origin.x  - CGFloat(sin(angle / Double(numberOfSegments) * Double(index)) * radius)
        let y = origin.y  - CGFloat(cos(angle / Double(numberOfSegments) * Double(index)) * radius)
        return CGPoint(x: x, y: y)
    }

}
