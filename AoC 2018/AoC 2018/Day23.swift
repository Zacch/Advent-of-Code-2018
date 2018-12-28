//
//  Day23.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-23.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation


class Day23 {
    
    var bots: [Bot] = []
    
    var deepestDepth = 0
    var deepestClusters: [Cluster] = []

    fileprivate func calculateIntersections(in botArray: [Bot]) {
        botArray.forEach { $0.intersecting = [] }

        for i in 0 ..< botArray.count {
            let bot = botArray[i]
            for j in i + 1 ..< botArray.count {
                let other = botArray[j]
                if bot.intersects(other) {
                    bot.intersecting.append(other)
                    other.intersecting.append(bot)
                }
            }
        }
    }
    
    fileprivate func recurseClusters(_ parent: Cluster, depth: Int) {
        var botsLeft = parent.bots
        while !botsLeft.isEmpty {
            calculateIntersections(in: botsLeft)
            let mostConnected = botsLeft.sorted(by: {b1, b2 in
                b1.intersecting.count > b2.intersecting.count ||
                b1.intersecting.count == b2.intersecting.count && b1.r > b2.r
            }).first!
            
            let cluster = Cluster(mostConnected, parent: parent, bots: mostConnected.intersecting, depth: depth)
            botsLeft.removeAll(where: { $0 == mostConnected || cluster.bots.contains($0) })
            parent.children.append(cluster)
            if depth > deepestDepth {
                deepestDepth = depth
                deepestClusters = []
                if depth % 10 == 0 {
                    print(depth)
                }
            }
            if cluster.depth == deepestDepth {
                deepestClusters.append(cluster)
            }
        }
        
        parent.children.filter { !$0.bots.isEmpty }.forEach { cluster in
            recurseClusters(cluster, depth: depth + 1)
        }
    }
    
    func findBotsInDeepestCluster() -> [Bot] {

        let rootCluster = Cluster(nil, parent: nil, bots: bots, depth: 0)
        
        recurseClusters(rootCluster, depth: 1)
        print("Depth:", deepestDepth)
        print(deepestClusters[0].center!)
        
        var targetBots:[Bot] = []
        var cluster = deepestClusters[0]
        while cluster.parent != nil {
            targetBots.append(cluster.center!)
            cluster = cluster.parent!
        }
        return targetBots
    }

    func solve () {
        let lines = Utils.readFileIntegers("Day23 part 2.txt")
        bots = lines.map { Bot($0) }
        
//        let strongestBot = bots.sorted(by: {$0.r > $1.r}).first!
//        print("Part1: \(bots.filter({strongestBot.canReach($0)}).count)")
//
//        let targetBots = findBotsInDeepestCluster()
        let targetBots = bots

//        for bot in targetBots {
//            print("pos=<\(bot.x),\(bot.y),\(bot.z)>, r=\(bot.r)")
//        }

        var minimum = Point3(x: Int.min, y: Int.min, z: Int.min)
        var maximum = Point3(x: Int.max, y: Int.max, z: Int.max)
        for bot in targetBots {
            minimum = Point3(x: max(minimum.x, bot.minX),
                             y: max(minimum.y, bot.minY),
                             z: max(minimum.z, bot.minZ))
            maximum = Point3(x: min(maximum.x, bot.maxX),
                             y: min(maximum.y, bot.maxY),
                             z: min(maximum.z, bot.maxZ))
        }
        print("Minimum: \(minimum)")
        print("Maximum: \(maximum)")
/*

 Minimum: [12,12,10]
 Maximum: [12,14,14]
    some: [10,12,12], r = 2

*/
        var size = maximum.x - minimum.x + maximum.y - minimum.y + maximum.z - minimum.z
        var lastSize = size + 1
        while size < lastSize {
            for bot in targetBots {
                var rangeLeft = bot.r
                if bot.x < minimum.x { rangeLeft -= minimum.x - bot.x }
                if bot.x > maximum.x { rangeLeft -= bot.x - maximum.x }
                if bot.y < minimum.y { rangeLeft -= minimum.y - bot.y }
                if bot.y > maximum.y { rangeLeft -= bot.y - maximum.y }
                let minZ = max(minimum.z, bot.z - rangeLeft)
                let maxZ = min(maximum.z, bot.z + rangeLeft)
                
                rangeLeft = bot.r
                if bot.x < minimum.x { rangeLeft -= minimum.x - bot.x }
                if bot.x > maximum.x { rangeLeft -= bot.x - maximum.x }
                if bot.z < minimum.z { rangeLeft -= minimum.z - bot.z }
                if bot.z > maximum.z { rangeLeft -= bot.z - maximum.z }
                let minY = max(minimum.y, bot.y - rangeLeft)
                let maxY = min(maximum.y, bot.y + rangeLeft)
                
                rangeLeft = bot.r
                if bot.y < minimum.y { rangeLeft -= minimum.y - bot.y }
                if bot.y > maximum.y { rangeLeft -= bot.y - maximum.y }
                if bot.z < minimum.z { rangeLeft -= minimum.z - bot.z }
                if bot.z > maximum.z { rangeLeft -= bot.z - maximum.z }
                let minX = max(minimum.x, bot.x - rangeLeft)
                let maxX = min(maximum.x, bot.x + rangeLeft)
                
                minimum = Point3(x: minX, y: minY, z: minZ)
                maximum = Point3(x: maxX, y: maxY, z: maxZ)
            }
            lastSize = size
            size = maximum.x - minimum.x + maximum.y - minimum.y + maximum.z - minimum.z
        }
        print()
        print("Maximum: \(maximum)")
        print("Minimum: \(minimum)")
        
        print("targetBots.count", targetBots.count)
        print("botsInRangeOf(minimum)", botsInRangeOf(minimum, targetBots))
        print("botsInRangeOf(maximum)", botsInRangeOf(maximum, targetBots))

        let botsOutside = targetBots.filter { !$0.canReach(minimum) }
        //     context.addRect(CGRect(x: Int(center.x) + 83, y: Int(center.y) + 66, width: 154, height: 210))

        for bot in botsOutside {
            var rangeLeft = bot.r
            if bot.y < minimum.y { rangeLeft -= minimum.y - bot.y }
            if bot.y > maximum.y { rangeLeft -= bot.y - maximum.y }
            if bot.z < minimum.z { rangeLeft -= minimum.z - bot.z }
            if bot.z > maximum.z { rangeLeft -= bot.z - maximum.z }

            if minimum.x + rangeLeft < bot.x - bot.r {
                print("\(bot) needs \(bot.x - bot.r - minimum.x)")
            }
        }
 
        
//        botsOutside.forEach {
//            print("drawCircle(x: \($0.y / 300000), y: \($0.z / 300000), r: \($0.r / 300000), in: context)")
//
//        }
//        let width = (maximum.x - minimum.x) / 30000
//        let height = (maximum.z - minimum.z) / 30000
//
//        print("context.addRect(CGRect(x: Int(center.x) + \(minimum.y / 300000), y: Int(center.y) + \(minimum.z / 300000), width: \(width), height: \(height)))")

        
//        targetBots.forEach {print($0.intersecting.count)}
        
//        let minBot = Bot([minimum.x, minimum.y, minimum.z, 0])
//        var minDistance = Int.max
//        for bot in targetBots {
//            minDistance = min(minDistance, bot.manhattanDistance(to: minBot) - bot.r)
//            print("\(minDistance) \(bot)")
//        }
//        for bot in targetBots {
//            if bot.x < minimum.x || bot.y < minimum.y || bot.z < minimum.z {
//                print("       \(bot)")
//                print("error")
//            }
//        }
//        for bot in targetBots {
//            if bot.manhattanDistance(to: minBot) > bot.r {
//                minDistance = min(minDistance, bot.manhattanDistance(to: minBot) - bot.r)
//                Utils.nop()
//            }
//        }
//        print("minDistance: \(minDistance)")
//        print(minBot.manhattanDistance(to: Bot([0, 0, 0, 0])))
//        print(minDistance + minBot.manhattanDistance(to: Bot([0, 0, 0, 0])))
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
//  75780131 is wrong.


class Cluster {
    let center: Bot?
    var bots: [Bot] = []
    let parent: Cluster?
    var children: [Cluster] = []
    let depth: Int
    
    init(_ center: Bot?, parent: Cluster?, bots: [Bot], depth: Int) {
        self.center = center
        self.parent = parent
        self.bots = bots
        self.depth = depth
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
