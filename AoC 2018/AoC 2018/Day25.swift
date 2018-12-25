//
//  Day25.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-25.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation


class Day25 {
    var constellations: [[Point4]] = []
    func solve () {
        let lines = Utils.readFileIntegers("Day25.txt")
        var stars: [Point4] = []
        for line in lines {
            stars.append(Point4(line))
        }
        var starsLeft = stars
        while !starsLeft.isEmpty {
            var constellation = [starsLeft.first!]
            var countBefore = 0
            while constellation.count > countBefore {
                countBefore = constellation.count
                for star in starsLeft {
                    if star.isInConstellation(constellation) {
                        constellation.append(star)
                    }
                }
                starsLeft = starsLeft.filter { !constellation.contains($0) }
            }
            constellations.append(constellation)
        }

        print("Part1: \(constellations.count)")
    }
}

class Point4: NSObject {
    let x: Int
    let y: Int
    let z: Int
    let t: Int
    init(_ ints:[Int]) {
        self.x = ints[0]
        self.y = ints[1]
        self.z = ints[2]
        self.t = ints[3]
    }
    
    func manhattanDistance(to other: Point4) -> Int {
        let deltaX: Int = abs(other.x - x)
        let deltaY: Int = abs(other.y - y)
        let deltaZ: Int = abs(other.z - z)
        let deltaT: Int = abs(other.t - t)
        return deltaX + deltaY + deltaZ + deltaT
    }

    func isInConstellation(_ constellation:[Point4]) -> Bool {
        return constellation.contains(where: { manhattanDistance(to: $0) <= 3 })
    }
    
    override var hash: Int  { get  { return x << 48 + y << 32 + z << 16 + t}}
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let point = object as? Point4 else {
            return false
        }
        return self.x == point.x && self.y == point.y &&
               self.z == point.z && self.t == point.t
    }

    override public var description: String {
        return "[\(x), \(y), \(z), \(t)]"
    }
    override var debugDescription: String {
        return description
    }
}
