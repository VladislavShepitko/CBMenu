//
//  Extensions.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/24/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

extension Double {
    var radians:Double{
        get{
            return self * M_PI / 180.0
        }
    }
    var degrees:Double {
        get {
            return self / M_PI * 180.0
        }
    }
}

func + (lp:CGPoint, rp:CGPoint) -> CGPoint
{
    return CGPoint(x: lp.x + rp.x, y: lp.y + rp.y)
}
func - (lp:CGPoint, rp:CGPoint) -> CGPoint
{
    return CGPoint(x: lp.x - rp.x, y: lp.y - rp.y)
}
func += (var lp:CGPoint, rp:CGPoint) -> CGPoint
{
    lp.x += rp.x
    lp.y += rp.y
    return lp
}
func -= (var lp:CGPoint, rp:CGPoint) -> CGPoint
{
    lp.x -= rp.x
    lp.y -= rp.y
    return lp
}
func * ( lp:CGPoint, mult:CGFloat) -> CGPoint
{
    return CGPoint(x: lp.x * mult, y: lp.y * mult)
}
func *= (var lp:CGPoint, mult:CGFloat) -> CGPoint
{
    lp.x *= mult
    lp.y *= mult
    return lp
}