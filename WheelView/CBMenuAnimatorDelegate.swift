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
    
    func showSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    func hideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    
    
    optional func didShowSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    optional func didHideSegment(menu:CBMenu, at indexPath:NSIndexPath, segment: CBMenuItem)
    
    
    
    
}
