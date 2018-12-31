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

extension Point4 {
    func isInConstellation(_ constellation:[Point4]) -> Bool {
        return constellation.contains(where: { manhattanDistance(to: $0) <= 3 })
    }
}
