//
//  Day09.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-07.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

struct Worker {
    var step = ""
    var timeLeft:UInt32 = 0
}

class Day07 {
    
    var steps: [String:String] = [:]
    var steps2: [String:String] = [:]

    func solve () {
        let lines = Utils.readFileLines("Day07.txt")
        for line in lines {
            let tokens = line.components(separatedBy: " ").map { String($0) }
            steps[tokens[7]] = (steps[tokens[7]] ?? "") + tokens[1]
            if steps[tokens[1]] == nil {
                steps[tokens[1]] = ""
            }
        }
        steps.forEach {k, v in steps2[k] = v }

        var nextStep: String? = ""
        var usedSteps: [String] = []
        while nextStep != nil {
            nextStep = steps.filter { k, v in
                return v.filter { c in !usedSteps.contains(String(c)) } == ""
            }.keys.sorted().first
            if nextStep != nil {
                usedSteps.append(nextStep!)
                steps = steps.filter { !usedSteps.contains($0.key) }
            }
        }
        print("Part1: \(usedSteps.reduce("", +))")
        
        var workers:[Worker] = Array(repeating: Worker(), count: 5)
        var completed: [String] = []
        var workLeft = true
        var time = -1
        while workLeft {
            time += 1
            workLeft = false
            for (index, _) in workers.enumerated() {
                if workers[index].timeLeft > 0 {
                    workers[index].timeLeft = workers[index].timeLeft - 1
                }
                if workers[index].timeLeft == 0 {
                    if workers[index].step != "" {
                        completed.append(workers[index].step)
                        workers[index].step = ""
                    }
                    nextStep = steps2.filter { k, v in
                        return v.filter { !completed.contains(String($0)) } == ""
                        }.keys.sorted().first
                    if nextStep != nil {
                        workers[index].step = nextStep!
                        workers[index].timeLeft = UnicodeScalar(nextStep!)!.value - 4
                        steps2.removeValue(forKey: workers[index].step)
                    }
                }
                if workers[index].step != "" {
                    workLeft = true
                }
            }
        }
        print("Part2: \(time)")
    }
    

}
