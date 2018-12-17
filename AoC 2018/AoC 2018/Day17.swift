//
//  Day17.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-16.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day17 {

    var top = 999
    var left = 999
    var bottom = 0
    var right = 0

    var ground:[[Character]] = []
    
    func solve () {
        let lines = Utils.readFileLines("Day17.txt")
        for line in lines {
            let digits = Utils.getIntegers(line)
            if line.starts(with: "x") {
                if left > digits[0] { left = digits[0] }
                if right < digits[0] { right = digits[0] }
                if top > digits[1] { top = digits[1] }
                if bottom < digits[2] { bottom = digits[2] }
            } else {
                if top > digits[0] { top = digits[0] }
                if bottom < digits[0] { bottom = digits[0] }
                if left > digits[1] { left = digits[1] }
                if right < digits[2] { right = digits[2] }
            }
        }
        print(Point(x: left, y: top))
        print(Point(x: right, y: bottom))

        ground = Array<[Character]>(repeating: Array<Character>(repeating: ".", count: bottom - top + 1), count: right - left + 1)

        for line in lines {
            let digits = Utils.getIntegers(line)
            if line.starts(with: "x") {
                let x = digits[0]
                for y in digits[1] ... digits[2] {
                    ground[x - left][y - top] = "#"
                }
            } else {
                let y = digits[0]
                for x in digits[1] ... digits[2] {
                    ground[x - left][y - top] = "#"
                }
            }
        }
        printGround()
        print()

        fallingWater(x: 500, y: top)
        printGround()

        print("Part1: \(countWaterReach())")
        print("Part2: ")
    }
    
    func printGround() {
        for y in top ... bottom {
            var line = ""
            for x in left ... right {
                line += String(ground[x - left][y - top])
            }
            print(line)
        }
    }

    func fallingWater(x: Int, y: Int) {
        ground[x - left][y - top] = "|"
        if y == bottom {
            return
        }
        if ground[x - left][y - top + 1] == "." {
            fallingWater(x: x, y: y + 1)
        } else {
            horizontalWater(x: x, y: y)
        }
    }

    func horizontalWater(x: Int, y: Int) {
        var isResting = true
        var leftEnd = x
        while leftEnd > left {
            if ground[leftEnd - left][y - top + 1] == "." {
                isResting = false
                break
            }
            if ground[leftEnd - left - 1][y - top] == "." {
                leftEnd -= 1
            } else {
                break
            }
        }

        var rightEnd = x
        while rightEnd < right {
            if ground[rightEnd - left][y - top + 1] == "." {
                isResting = false
                break
            }
            if ground[rightEnd - left + 1][y - top] == "." {
                rightEnd += 1
            } else {
                break
            }
        }
        
        if isResting {
            for x in leftEnd ... rightEnd {
                ground[x - left][y - top] = "~"
            }
            horizontalWater(x: x, y: y - 1)
        } else {
            for x in leftEnd ... rightEnd {
                ground[x - left][y - top] = "|"
            }
            if ground[leftEnd - left][y - top + 1] == "." {
                fallingWater(x: leftEnd, y:y)
            }
            if ground[rightEnd - left][y - top + 1] == "." {
                fallingWater(x: rightEnd, y:y)
            }
        }
    }
    
    func countWaterReach() -> Int {
        return ground.reduce(0, {$0 + $1.filter({ $0 == "~" || $0 == "|"}).count})
    }
}
