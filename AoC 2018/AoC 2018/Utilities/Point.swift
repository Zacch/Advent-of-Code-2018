//
//  Point.swift
//  Advent Of Code 2017
//
//  Created by Rolf Staflin on 2017-12-11.
//  Copyright © 2017 Piro AB. All rights reserved.
//

import Foundation
class Point: NSObject {
    let x: Int
    let y: Int
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func turnLeft() -> Point {
        return Point(x:-y, y:x)
    }
    
    func turnRight() -> Point {
        return Point(x:y, y:-x)
    }
    
    func reverse() -> Point {
        return Point(x:-x, y:-y)
    }

    override public var description: String {
        return "[\(x),\(y)]"
    }
}

func +(lhs:Point, rhs:Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func -(lhs:Point, rhs:Point) -> Point {
    return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

