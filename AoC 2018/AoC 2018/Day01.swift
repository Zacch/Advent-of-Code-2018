//
//  Day01.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-01.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day01 {
    func solve () {
        let lines = Utils.readFileLines("Day01.txt")
        var sum = 0
        for line in lines {
            sum += Int(line)!
        }
        print("Part 1: \(sum)")
        
        var frequency = 0
        var seenFrequencies: Set<Int> = []
        var done = false
        while (!done) {
            for line in lines {
                frequency += Int(line)!
                if seenFrequencies.contains(frequency) {
                    done = true
                    break
                }
                seenFrequencies.insert(frequency)
            }
        }
        print("Part 2: \(frequency)")
    }
}
