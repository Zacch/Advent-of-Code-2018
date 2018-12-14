//
//  Day14.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-14.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day14 {

    let input = 440231
    var inputString = ""
    var inputLength = 0
    var scores: [Int] = []
    var numberOfScores = 2
    var part2 = -1

    func solve () {
        inputString = String(input)
        inputLength = inputString.count
        scores = Array<Int>(repeating: -1, count: input * 50 + 12)
        scores[0] = 3
        scores[1] = 7
        var e1 = 0
        var e2 = 1
        while (numberOfScores <= input * 50 + 10) {
            let sum = scores[e1] + scores[e2]
            if sum > 9 {
                scores[numberOfScores] = 1
                numberOfScores += 1
                test()
            }
            scores[numberOfScores] = sum % 10
            numberOfScores += 1
            test()
            e1 = (e1 + 1 + scores[e1]) % numberOfScores
            e2 = (e2 + 1 + scores[e2]) % numberOfScores
        }
        let part1 = scores[input ..< input + 10].map { String($0) }.reduce("", +)
        print("Part1: \(part1)")
        print("Part2: \(part2)")
    }
    
    func test() {
        if numberOfScores < inputLength  || part2 > 0 {
            return
        }
        let s = scores[numberOfScores - inputLength ..< numberOfScores].map { String($0) }.reduce("", +)
        if s == inputString {
            part2 = numberOfScores - inputLength
        }
    }
}
