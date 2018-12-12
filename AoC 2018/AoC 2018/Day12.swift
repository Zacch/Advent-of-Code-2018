//
//  Day12.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-12.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day12 {

    let repetitionLimit = 5
    let offset = 1000
    var state = ""
    var rules: [String:String] = [:]
    
    func solve () {
        let lines = Utils.readFileLines("Day12.txt")
        let initialState = lines[0].components(separatedBy: " ").map { String($0) }.last!
        let padding = String(Array<Character>(repeating: ".", count: offset))
        state = "\(padding)\(initialState)\(padding)"

        for line in lines.dropFirst() {
            let tokens = line.components(separatedBy: " => ").map { String($0) }
            rules[tokens[0]] = tokens[1]
        }

        for _ in 1 ... 20 {
            evolve()
        }
        print("Part1: \(calculateScore())")

        var lastScore = 0
        var lastDiff = 0
        var repetitions = 0
        for i in 21 ... offset / 2 {
            evolve()
            let score = calculateScore()
            let diff = score - lastScore
            if diff == lastDiff {
                repetitions += 1
                if repetitions >= repetitionLimit {
                    print("Part2: \(score + diff * (50000000000 - i))")
                    break
                }
            } else {
                repetitions = 0
            }
            lastScore = score
            lastDiff = diff
        }
    }
    
    func evolve() {
        let padded = "..\(state).."
        var result = ""
        for i in 0 ..< padded.count - 4 {
            let start = padded.index(padded.startIndex, offsetBy: i)
            let stop = padded.index(start, offsetBy: 4)

            let substring = padded[start...stop]
            result += rules[String(substring)]!
        }
        state = String(result)
    }
    
    func calculateScore() -> Int {
        let nsstate = NSString(string:state)
        var result = 0
        for i in 0 ..< nsstate.length {
            if nsstate.character(at: i) == "#".utf16.first {
                result += (i - offset)
            }
        }
        return result
    }
}
