//
//  Day23.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-23.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Bot: NSObject {
    let x: Int
    let y: Int
    let z: Int
    let r: Int
    
    var inReach = 0
    
    init(_ ints: [Int]) {
        x = ints[0]
        y = ints[1]
        z = ints[2]
        r = ints[3]
    }
    
    func canReach(_ other:  Bot) -> Bool {
        let manhattanDistance = abs(other.x - x) + abs(other.y - y) + abs(other.z - z)
        return (manhattanDistance <= r)
    }
    
    override public var description: String {
        return "\(inReach) [\(x), \(y), \(z)], r = \(r)"
    }
}

class Day23 {
    
    var bots: [Bot] = []

    func solve () {
        let lines = Utils.readFileIntegers("Day23.txt")
        bots = lines.map { Bot($0) }
        let strongestBot = bots.sorted(by: {$0.r > $1.r}).first!
        print("Part1: \(bots.filter({strongestBot.canReach($0)}).count)")
    }
}
