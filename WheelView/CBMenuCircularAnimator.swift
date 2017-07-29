//
//  CBMenuCircularAnimator.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class CBMenuCircularAnimator: CBMenuAnimatorDelegate {
    weak  var owner:CBMenu?
    
    init(withOwner owner:CBMenu){
        self.owner = owner
    }
    
    func destenationPositionForSegment(at indexPath:NSIndexPath)->CGPoint{
        return CGPointZero
    }
    
    
    
    func showSegment(at indexPath:NSIndexPath, segment: CBMenuItem)
    {
    
    }
    func hideSegment(at indexPath:NSIndexPath, segment: CBMenuItem){
    
    }
    
}
