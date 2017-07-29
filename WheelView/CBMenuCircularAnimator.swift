//
//  CBMenuCircularAnimator.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@objc class CBMenuCircularAnimator: NSObject, CBMenuAnimatorDelegate {
    
    
    
    func destenationPositionForSegment(at indexPath:NSIndexPath)->CGPoint{
        return CGPointZero
    }
    
    func showSegment(at indexPath:NSIndexPath, segment: CBMenuItem)
    {
        print("show \(indexPath.item) element in \(segment.destenationPosition)")
    }
    func hideSegment(at indexPath:NSIndexPath, segment: CBMenuItem){
        print("hide \(indexPath.item) element in \(segment.destenationPosition)")
    }
    
    //MARK:- helper functions
    func pointOnCircle(origin:CGPoint, numberOfSegments:Int, angle:Double,index:Int,radius:Double) -> CGPoint {
        let x = origin.x  - CGFloat(sin(angle / Double(numberOfSegments) * Double(index)) * radius)
        let y = origin.y  - CGFloat(cos(angle / Double(numberOfSegments) * Double(index)) * radius)
        return CGPoint(x: x, y: y)
    }
    
}
