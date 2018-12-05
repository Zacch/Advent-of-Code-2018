//
//  Day05.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-05.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day05 {
    
    func solve () {
        let lines = Utils.readFileLines("Day05.txt")
        
        let line = lines[0]
        print("Part1: \(reduceLine(line))")
        
        var shortest = line.count
        for char in "abcdefghijklmnopqrstuvwxyz" {
            print(char)
            var l1 = line
            l1.removeAll(where:{ $0 == char})
            l1.removeAll(where:{ $0 == Character(String(char).uppercased())})
            let length = reduceLine(l1)
            if length < shortest {
                shortest = length
            }
        }
        print("Part2: \(shortest)")
    }

    fileprivate func reduceLine(_ s: String) -> Int {
        var line = s
        var lastCount = -1
        while line.count != lastCount {
            lastCount = line.count
            var i = 0
            while i < line.count - 1 {
                let i1 = line.index(line.startIndex, offsetBy: i)
                let i2 = line.index(line.startIndex, offsetBy: i + 1)
                let c1 = line[i1]
                let c2 = line[i2]
                if c1 != c2 && Character(String(c1).uppercased()) == Character(String(c2).uppercased()) {
                    line.remove(at: i2)
                    line.remove(at: i1)
                    i = max(i - 1, 0)
                } else {
                    i += 1
                }
            }
        }
        return line.count
    }
}
