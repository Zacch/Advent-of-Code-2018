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

    override var hash: Int  { get  { return x << 32 | y }}

    override func isEqual(_ object: Any?) -> Bool {
        guard let point = object as? Point else {
            return false
        }
        return self.x == point.x && self.y == point.y
    }
    
    func isAdjacent(to other: Point) -> Bool{
        return (y == other.y && abs(x - other.x) == 1) ||
               (x == other.x && abs(y - other.y) == 1)
    }

    func up() -> Point {
        return Point(x:x, y:y - 1)
    }
    
    func down() -> Point {
        return Point(x:x, y:y + 1)
    }
    
    func left() -> Point {
        return Point(x:x - 1, y:y)
    }
    
    func right() -> Point {
        return Point(x:x + 1, y:y)
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
    
    func manhattanDistance(to other: Point) -> Int {
        return abs(other.x - x) + abs(other.y - y)
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

