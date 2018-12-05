//
//  Day04.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-04.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Guard: Hashable {

    let id: Int
    var timeAsleep = 0
    var asleepMinute = Array<Int>(repeating: 0, count: 60)
    
    init(_ id: Int) {
        self.id = id
    }
    
    func sleep(from: Int, to: Int) {
        timeAsleep += to - from
        for i in from ..< to {
            asleepMinute[i] += 1
        }
    }

    func sleepiestMinute() -> Int {
        var result = -1
        var sleepiestSoFar = -1
        for i in 0 ..< 60 {
            if asleepMinute[i] > sleepiestSoFar {
                sleepiestSoFar = asleepMinute[i]
                result = i
            }
        }
        return result
    }

    static func == (lhs: Guard, rhs: Guard) -> Bool {
        return lhs.id == rhs.id
    }
    public var hashValue: Int { get { return  id } }
}

class Day04 {
    
    var guards:[Int: Guard] = [:]
    
    func solve () {
        let lines = Utils.readFileLines("Day04.txt")
        var guardOnDuty = Guard(-1)
        var sleepStart = -1
        for line in lines.sorted() {
            let tokens = line.components(separatedBy: " ").map { String($0) }
            switch tokens[2] {
            case "Guard":
                let id = Int(tokens[3].dropFirst())!
                var guardian = guards[id]
                if guardian == nil {
                    guardian = Guard(id)
                    guards[id] = guardian
                }
                guardOnDuty = guardian!
            case "falls":
                if sleepStart != -1 {
                    exit(43)
                }
                let minute = Int(tokens[1].split(separator: ":").map { String($0) }[1].dropLast())!
                sleepStart = minute
            case "wakes":
                let minute = Int(tokens[1].split(separator: ":").map { String($0) }[1].dropLast())!
                guardOnDuty.sleep(from: sleepStart, to: minute)
                sleepStart = -1
            default:
                exit(42)
            }
        }
        let sleepiestGuard = guards.max { a, b in a.value.timeAsleep < b.value.timeAsleep }!.value
        let bestMinute = sleepiestGuard.sleepiestMinute()
        print("Part1: \(sleepiestGuard.id * bestMinute)")
        
        var id = -1
        var minute = -1
        var sleepMax = -1
        for guardian in guards.values {
            let bestMinute = guardian.sleepiestMinute()
            if bestMinute > sleepMax {
                sleepMax = bestMinute
                id = guardian.id
                minute = bestMinute
            }
        }
        
        print("Part2: \(id * minute)")
    }
}
