//
//  Day23.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-23.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

extension Point4 {
    var distanceTo3dOrigin: Int { get { return abs(x) + abs(y) + abs(z) } }
}

class Day23 {
    
    var bots: [Bot] = []

    func solve () {
        let lines = Utils.readFileIntegers("Day23.txt")
        bots = lines.map { Bot($0) }
        
        let strongestBot = bots.sorted(by: {$0.r > $1.r}).first!
        print("Part1: \(bots.filter({strongestBot.canReach($0)}).count)")

        print("Part 2: \(part2())")
    }

    func part2() -> Int {
        let granularity = 128

        calculateIntersections(in: bots)
        let sortedBots = bots.sorted(by: {$0.intersecting.count > $1.intersecting.count })
        var intersectionCount = 0
        for i in 0 ..< sortedBots.count {
            if sortedBots[i].intersecting.count < i {
                intersectionCount = i
                break
            }
        }
        
        var intersectingBots = sortedBots[0 ..< intersectionCount]

        // Find a good starting point for the search
        var p = Point3(divideAndSearch(Array(intersectingBots)))
        var botsInRange = intersectingBots.filter { $0.canReach(p) }
        var notInRange =  intersectingBots.filter { !$0.canReach(p) }

        while !notInRange.isEmpty {
            // Walk closer to the first bot that is not in range
            let bot = notInRange.first!
            
            var xStep = bot.x - p.x / granularity
            var yStep = bot.y - p.y / granularity
            var zStep = bot.z - p.z / granularity
            let oldP = p
            while xStep != 0 || yStep != 0 || zStep != 0 {
                let nextP = Point3(x: p.x + xStep, y: p.y + yStep, z: p.z + zStep)
                let outside = botsInRange.filter({ !$0.canReach(nextP) })
                if (!outside.isEmpty) {
                    xStep /= 2
                    yStep /= 2
                    zStep /= 2
                } else {
                    p = nextP
                    if bot.canReach(p) {
                        break
                    }
                }
            }
            
            if oldP == p {
                var nextP = Point3(x: p.x + 1, y: p.y, z: p.z)
                if botsInRange.filter({ !$0.canReach(nextP) }).isEmpty {
                    p = nextP
                } else {
                    nextP = Point3(x: p.x - 1, y: p.y, z: p.z)
                    if botsInRange.filter({ !$0.canReach(nextP) }).isEmpty {
                        p = nextP
                    } else {
                        nextP = Point3(x: p.x, y: p.y + 1, z: p.z)
                        if botsInRange.filter({ !$0.canReach(nextP) }).isEmpty {
                            p = nextP
                        } else {
                            nextP = Point3(x: p.x, y: p.y - 1, z: p.z)
                            if botsInRange.filter({ !$0.canReach(nextP) }).isEmpty {
                                p = nextP
                            } else {
                                nextP = Point3(x: p.x, y: p.y, z: p.z + 1)
                                if botsInRange.filter({ !$0.canReach(nextP) }).isEmpty {
                                    p = nextP
                                } else {
                                }
                                nextP = Point3(x: p.x, y: p.y, z: p.z - 1)
                                if botsInRange.filter({ !$0.canReach(nextP) }).isEmpty {
                                    p = nextP
                                } else {
                                    // Ignore this bot and try another one
                                    intersectingBots = intersectingBots.filter({ $0 != bot })
                                }
                            }
                        }
                    }
                }
            }
            botsInRange = intersectingBots.filter { $0.canReach(p) }
            notInRange =  intersectingBots.filter({ !$0.canReach(p) }).sorted(by: { $0.manhattanDistance(to: p) - $0.r > $1.manhattanDistance(to: p) - $1.r })
        }

        return p.manhattanDistance(to: Point3(x: 0,y: 0,z: 0))
    }

    fileprivate func calculateIntersections(in botArray: [Bot]) {
        botArray.forEach { $0.intersecting = [] }
        
        for i in 0 ..< botArray.count {
            let bot = botArray[i]
            for j in i + 1 ..< botArray.count {
                let other = botArray[j]
                if bot.intersects(other) {
                    bot.intersecting.append(other)
                }
                if other.intersects(bot) {
                    other.intersecting.append(bot)
                }
            }
        }
    }

    
    fileprivate func divideAndSearch(_ bots: [Bot]) -> Point4 {
        let granularity = 4

        var bestPoint = Point4([0,0,0,0])
        var minimum = Point3(x: (4 << 30), y: (4 << 30), z: (4 << 30))
        var maximum = Point3(x: -(4 << 30), y: -(4 << 30), z: -(4 << 30))
        for bot in bots {
            minimum = Point3(x: min(minimum.x, bot.minX),
                             y: min(minimum.y, bot.minY),
                             z: min(minimum.z, bot.minZ))
            maximum = Point3(x: max(maximum.x, bot.maxX),
                             y: max(maximum.y, bot.maxY),
                             z: max(maximum.z, bot.maxZ))
        }
        
        var xStep = (maximum.x - minimum.x) / granularity
        var yStep = (maximum.y - minimum.y) / granularity
        var zStep = (maximum.z - minimum.z) / granularity
        while xStep > 0 || yStep > 0 || zStep > 0 {
            var points: [Point4] = []
            for x1 in 0 ... granularity {
                let x = minimum.x + x1 * xStep
                for y1 in 0 ... granularity {
                    let y = minimum.y + y1 * yStep
                    for z1 in 0 ... granularity {
                        let z = minimum.z + z1 * zStep
                        points.append(Point4(x: x, y: y, z: z, t: botsInRangeOf(Point3(x: x, y: y, z: z), bots)))
                    }
                }
            }
            let sortedPoints = points.sorted(by: { $0.t > $1.t ||
                ($0.t == $1.t && $0.distanceTo3dOrigin < $1.distanceTo3dOrigin) })
            bestPoint = sortedPoints.first!
            minimum = Point3(x: bestPoint.x - xStep, y: bestPoint.y - yStep, z: bestPoint.z - zStep)
            maximum = Point3(x: bestPoint.x + xStep, y: bestPoint.y + yStep, z: bestPoint.z + zStep)
            if sortedPoints.first!.t > sortedPoints.last!.t {
                xStep = (maximum.x - minimum.x) / granularity
                yStep = (maximum.y - minimum.y) / granularity
                zStep = (maximum.z - minimum.z) / granularity
            }
            else {
                print("foo")
            }
        }
        return bestPoint
    }
    
    func botsInRangeOf(_ point: Point3, _ bots:[Bot]) -> Int {
        return (bots.filter { $0.canReach(point) }.count)
    }
}

class Bot: NSObject {
    let x: Int
    let y: Int
    let z: Int
    let r: Int
    
    var minX: Int { get { return x - r }}
    var maxX: Int { get { return x + r }}
    var minY: Int { get { return y - r }}
    var maxY: Int { get { return y + r }}
    var minZ: Int { get { return z - r }}
    var maxZ: Int { get { return z + r }}
    var intersecting:[Bot] = []
    
    init(_ ints: [Int]) {
        x = ints[0]
        y = ints[1]
        z = ints[2]
        r = ints[3]
    }

    func manhattanDistance(to other: Bot) -> Int {
        let deltaX: Int = abs(other.x - x)
        let deltaY: Int = abs(other.y - y)
        let deltaZ: Int = abs(other.z - z)
        return deltaX + deltaY + deltaZ
    }

    func manhattanDistance(to point: Point3) -> Int {
        let deltaX: Int = abs(point.x - x)
        let deltaY: Int = abs(point.y - y)
        let deltaZ: Int = abs(point.z - z)
        return deltaX + deltaY + deltaZ
    }

    func canReach(_ other:  Bot) -> Bool {
        return (manhattanDistance(to: other) <= r)
    }
    
    func canReach(_ point:  Point3) -> Bool {
        return (manhattanDistance(to: point) <= r)
    }

    func intersects(_ other:  Bot) -> Bool {
        return (manhattanDistance(to: other) <= r + other.r)
    }
    
    override var hash: Int  { get  { return x << 49 + y << 32 + z << 16 + r }}
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Bot else {
            return false
        }
        return self.x == other.x && self.y == other.y && self.z == other.z && self.r == other.r
    }
    
    override public var description: String {
        return "\(intersecting.count) [\(x), \(y), \(z)], r = \(r)"
    }
}
