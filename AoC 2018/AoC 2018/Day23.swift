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
    
    let granularity = 12

    fileprivate func divideAndSearch(_ bots: [Bot]) -> Point4 {
        var bestPoint = Point4([0,0,0,0])
        var minimum = Point3(x: -(4 << 30), y: -(4 << 30), z: -(4 << 30))
        var maximum = Point3(x: (4 << 30), y: (4 << 30), z: (4 << 30))
        for bot in bots {
            minimum = Point3(x: min(minimum.x, bot.minX),
                             y: min(minimum.y, bot.minY),
                             z: min(minimum.z, bot.minZ))
            maximum = Point3(x: max(maximum.x, bot.maxX),
                             y: max(maximum.y, bot.maxY),
                             z: max(maximum.z, bot.maxZ))
        }
        
        print(minimum)
        print(maximum)
        
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
            print(bestPoint, bestPoint.manhattanDistance(to: Point4([0, 0, 0, bestPoint.t])), xStep, yStep, zStep)
            minimum = Point3(x: bestPoint.x - xStep * 5, y: bestPoint.y - yStep * 5, z: bestPoint.z - zStep * 5)
            maximum = Point3(x: bestPoint.x + xStep * 5, y: bestPoint.y + yStep * 5, z: bestPoint.z + zStep * 5)
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
    
    /// This implementation is way too inefficient – there are millions of points on the "frontier" 
    func searchFrontier(_ p: Point4) -> Point4 {
        print("searchFrontier(\(p)) \(p.distanceTo3dOrigin)")
        var frontier: [Point4] = [p]
        var visited: [Point4] = []

        let botCount = p.t
        let distanceToOrigin = p.distanceTo3dOrigin

        var count = 0
        while !frontier.isEmpty {
            let current = frontier.popLast()!
            let neighbours: [Point4] = neighboursOf(current)
            for next in neighbours {
                if next.t < botCount {
                    continue
                }
                if next.distanceTo3dOrigin < distanceToOrigin || next.t > botCount {
                    return searchFrontier(next)
                }
                if next.distanceTo3dOrigin == distanceToOrigin && !visited.contains(next) {
                    frontier.append(next)
                    visited.append(next)
                }
            }
            count += 1
            if count % 1000 == 0 {
                print(visited.count)
            }
        }
        print("searchFrontier(\(p)) returning!")
        return p
    }

    /// The neighbours that are at least as close to origin as p (if all coords of p are > 0)
    func neighboursOf(_ p:Point4) -> [Point4] {
        var neighbours: [Point4] = []
        neighbours.append(Point4(x: p.x - 1, y: p.y, z: p.z, t: botsInRangeOf(Point3(x: p.x - 1, y: p.y, z: p.z), bots)))
        neighbours.append(Point4(x: p.x, y: p.y - 1, z: p.z, t: botsInRangeOf(Point3(x: p.x, y: p.y - 1, z: p.z), bots)))
        neighbours.append(Point4(x: p.x, y: p.y, z: p.z - 1, t: botsInRangeOf(Point3(x: p.x, y: p.y, z: p.z - 1), bots)))

        neighbours.append(Point4(x: p.x - 1, y: p.y + 1, z: p.z, t: botsInRangeOf(Point3(x: p.x - 1, y: p.y + 1, z: p.z), bots)))
        neighbours.append(Point4(x: p.x - 1, y: p.y, z: p.z + 1, t: botsInRangeOf(Point3(x: p.x - 1, y: p.y, z: p.z + 1), bots)))
        neighbours.append(Point4(x: p.x + 1, y: p.y - 1, z: p.z, t: botsInRangeOf(Point3(x: p.x + 1, y: p.y - 1, z: p.z), bots)))
        neighbours.append(Point4(x: p.x, y: p.y - 1, z: p.z + 1, t: botsInRangeOf(Point3(x: p.x, y: p.y - 1, z: p.z + 1), bots)))
        neighbours.append(Point4(x: p.x + 1, y: p.y, z: p.z - 1, t: botsInRangeOf(Point3(x: p.x + 1, y: p.y, z: p.z - 1), bots)))
        neighbours.append(Point4(x: p.x, y: p.y + 1, z: p.z - 1, t: botsInRangeOf(Point3(x: p.x, y: p.y + 1, z: p.z - 1), bots)))

        return neighbours.sorted(by: { $0.t > $1.t ||
            ($0.t == $1.t && $0.distanceTo3dOrigin < $1.distanceTo3dOrigin) })
    }

    func solve () {
        let lines = Utils.readFileIntegers("Day23.txt")
        bots = lines.map { Bot($0) }
        
        let strongestBot = bots.sorted(by: {$0.r > $1.r}).first!
        print("Part1: \(bots.filter({strongestBot.canReach($0)}).count)")
//
//        var botDistance: [Int] = []
//
//        for bot in bots {
//            let distance = bot.closestToZero()
//            if !botDistance.contains(distance) {
//                botDistance.append(distance)
//            }
//        }
//        for distance in botDistance.sorted() {
//            print(distance, bots.filter({ $0.closestToZero() <= distance && $0.farthestFromZero() >= distance }).count)
//        }
        let approximation = divideAndSearch(bots)
        let bestPoint = searchFrontier(approximation)
        print("--->", bestPoint)
        print("Part 2: \(bestPoint.distanceTo3dOrigin)")
    }
    
    func botsInRangeOf(_ bot: Bot, _ bots:[Bot]) -> Int {
        return (bots.filter { $0.canReach(bot) }.count)
    }
    
    func botsInRangeOf(_ point: Point3, _ bots:[Bot]) -> Int {
        return (bots.filter { $0.canReach(point) }.count)
    }
}


// 119006026 is too high
//  99011840 is too high
//  75629842 is too low
//  75780131 is wrong
//  84087794 is wrong
//  77958168 is wrong
//  77767601 is wrong


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
    
    func closestToZero() -> Int {
        return max(0, manhattanDistance(to: Point3(x: 0, y: 0, z: 0)) - r)
    }
    
    func farthestFromZero() -> Int {
        return max(0, manhattanDistance(to: Point3(x: 0, y: 0, z: 0)) + r)
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
