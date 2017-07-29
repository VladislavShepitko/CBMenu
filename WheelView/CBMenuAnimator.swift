//
//  CBMenuAnimator.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/29/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@objc protocol CBMenuAnimatorDelegate: class {
    
    weak var owner:CBMenu? {get set}
    
    init(withOwner owner:CBMenuItem)
    
    func destenationPositionForSegment(at indexPath:NSIndexPath)->CGPoint
    
    
    optional func willShowSegment(at indexPath:NSIndexPath, segment: CBMenuItem)
    optional func willHideSegment(at indexPath:NSIndexPath, segment: CBMenuItem)
    
    func showSegment(at indexPath:NSIndexPath, segment: CBMenuItem)
    func hideSegment(at indexPath:NSIndexPath, segment: CBMenuItem)
    
    
    optional func didShowSegment(at indexPath:NSIndexPath, segment: CBMenuItem)
    optional func didHideSegment(at indexPath:NSIndexPath, segment: CBMenuItem)
    
    
    
    
}
