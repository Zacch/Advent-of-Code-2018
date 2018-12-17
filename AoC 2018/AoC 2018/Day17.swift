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
        
        left -= 1
        right += 1

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

        fallingWater(x: 500, y: top)

        print("Part1: \(ground.reduce(0, {$0 + $1.filter({ $0 == "~" || $0 == "|"}).count}))")
        print("Part2: \(ground.reduce(0, {$0 + $1.filter({ $0 == "~"}).count}))")
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

    func fallingWater(x: Int, y startY: Int) {
        var y = startY
        
        var done = false
        while !done {
            switch ground[x - left][y - top] {
            case ".":
                Utils.nop()
            case "~":
                done = true
            case "|":
                done = true
            case "#":
                error()
            default:
                error()
            }
            if y == bottom {
                ground[x - left][y - top] = "|"
                done = true
            } else {
                if "~#".contains(ground[x - left][y - top + 1]) {
                    horizontalWater(x: x, y: y)
                    done = true
                } else {
                    ground[x - left][y - top] = "|"
                    y += 1
                }
            }
        }
    }

    func horizontalWater(x: Int, y startY: Int) {
        if "~|".contains(ground[x - left][startY - top]) {
            return
        }
        var y = startY
        var done = false
        while !done {
            if !".|".contains(ground[x - left][y - top]) {
                print(ground[x - left][y - top])
                ground[x - left][y - top] = "*"
                error()
            }
            var isResting = true
            var leftEnd = x
            var endFound = false
            while leftEnd > left && !endFound {
                switch ground[leftEnd - left][y - top + 1] {
                case ".":
                    isResting = false
                    endFound = true
                case "#":
                    Utils.nop()
                case "|":
                    isResting = false
                    endFound = true
                case "~":
                    Utils.nop()
                default:
                    error()
                }
                
                if !endFound {
                    switch ground[leftEnd - left - 1][y - top] {
                    case ".":
                        leftEnd -= 1
                    case "#":
                        endFound = true
                    case "|":
                        leftEnd -= 1
                    case "~":
                        error()
                    default:
                        error()
                    }
                }
            }
            
            var rightEnd = x
            endFound = false
            while rightEnd < right && !endFound {
                switch ground[rightEnd - left][y - top + 1] {
                case ".":
                    isResting = false
                    endFound = true
                case "#":
                    Utils.nop()
                case "|":
                    isResting = false
                    endFound = true
                case "~":
                    Utils.nop()
                default:
                    error()
                }
                
                if !endFound {
                    switch ground[rightEnd - left + 1][y - top] {
                    case ".":
                        rightEnd += 1
                    case "#":
                        endFound = true
                    case "|":
                        rightEnd += 1
                    case "~":
                        error()
                    default:
                        error()
                    }
                }
            }
            
            if isResting {
                for x in leftEnd ... rightEnd {
                    ground[x - left][y - top] = "~"
                }
                y -= 1
            } else {
                done = true
                for x in leftEnd ... rightEnd {
                    ground[x - left][y - top] = "|"
                }
                if ground[leftEnd - left][y - top + 1] == "." {
                    fallingWater(x: leftEnd, y:y + 1)
                }
                if ground[rightEnd - left][y - top + 1] == "." {
                    fallingWater(x: rightEnd, y:y + 1)
                }
            }
        }
    }
    
    func error() {
        printGround()
        print("Error!")
    }
}
