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
                if depth % 50 == 0 {
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
    
    func solve () {
        let lines = Utils.readFileIntegers("Day23.txt")
        bots = lines.map { Bot($0) }
        
        let strongestBot = bots.sorted(by: {$0.r > $1.r}).first!
        print("Part1: \(bots.filter({strongestBot.canReach($0)}).count)")
        
//        print(bots.map { $0.intersecting.count})
//        bots.filter({ $0.intersecting.count < 900 }).forEach {print($0)}

        let rootCluster = Cluster(nil, parent: nil, bots: bots, depth: 0)

        recurseClusters(rootCluster, depth: 1)
        Utils.nop()
    }
}


// 119006026 is too high


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
    
    func canReach(_ other:  Bot) -> Bool {
        return (manhattanDistance(to: other) <= r)
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
