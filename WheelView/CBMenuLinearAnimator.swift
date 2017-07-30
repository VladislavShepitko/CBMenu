//
//  CBMenuCircularAnimator.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@objc class CBMenuLinearAnimator: NSObject {
    //MARK:- parameters for linear placement of segments
    let xOffset:CGFloat = 40.0
    var curOffset:CGPoint = CGPointZero
    
    
}
//MARK:- delegate implementation
extension CBMenuLinearAnimator : CBMenuAnimatorDelegate {
    func destenationPositionForSegment(menu:CBMenu, at indexPath:NSIndexPath)->CGPoint{
        let direction:CGFloat = indexPath.item % 2 == 0 ? 1 : -1
        curOffset = direction > 0 ? CGPointMake(curOffset.x + xOffset, 0) : curOffset
        
        return menu.origin + curOffset * direction
    }
    
    func animateBackgroundWhenShow(menu: CBMenu) {
        
    }
    
    func animateBackgroundWhenHide(menu: CBMenu) {
        
    }
    

}
