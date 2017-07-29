//
//  Extensions.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/24/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation

extension Double {
    var radians:Double{
        get{
            return self * M_PI / 180.0
        }
    }
    var degrees:Double {
        get {
            return 0.0
        }
    }
}