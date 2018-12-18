//
//  Day18.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-18.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day18 {
    
    var acres:[[Character]] = []
    var height = 0
    var width = 0
    var emptyLand:[Character] = []
    var landMap:[String: Int] = [:]

    func solve () {
        let lines = Utils.readFileLines("Day18.txt")
        height = lines.count
        width = lines[0].count
        emptyLand = Array<Character>(repeating: ".", count: width + 2)
        acres.append(emptyLand)
        for line in lines {
            acres.append(Array("." + line + "."))
        }
        acres.append(emptyLand)
        // acres.forEach { print(String($0))}

        for i in 1 ... 10 {
            evolve()
            landMap[acres.reduce("", {$0 + String($1)})] = i
        }

        let trees = acres.reduce(0, {$0 + $1.filter({ $0 == "|" }).count})
        let lumberyards = acres.reduce(0, {$0 + $1.filter({ $0 == "#" }).count})
        print("Part1: \(trees * lumberyards)")
        
        
        for i in 11 ... 1000000000 {
            evolve()
            let acreString = acres.reduce("", {$0 + String($1)})

            if let previousTime = landMap[acreString] {
                let period = i - previousTime
                let time = previousTime + ((1000000000 - previousTime) % period)
                let land = landMap.filter({_, v in v == time}).first!.key
                let trees = land.filter({ $0 == "|" }).count
                let lumberyards = land.filter({ $0 == "#" }).count
                print("Part 2: \(trees * lumberyards)")
                break
            } else {
                landMap[acreString] = i
            }
        }
    }
    
    func evolve() {
        var newAcres:[[Character]] = [emptyLand]
        for row in 1 ... height {
            var line: [Character] = ["."]
            for column in 1 ... width {
                let neighbors = neighborsOf(row, column)
                let trees = neighbors.filter({ $0 == "|" }).count
                let lumberYards = neighbors.filter({ $0 == "#" }).count
                switch acres[row][column] {
                case ".":
                    line.append(trees > 2 ? "|" : ".")
                case "|":
                    line.append(lumberYards > 2 ? "#" : "|")
                case "#":
                    line.append((lumberYards > 0 && trees > 0) ? "#" : ".")
                default:
                    print("Error")
                }
            }
            line.append(".")
            newAcres.append(line)
        }
        newAcres.append(emptyLand)
        acres = newAcres
    }
    
    func neighborsOf(_ row: Int, _ column: Int) -> [Character] {
        var result: [Character] = []
        result.append(contentsOf: acres[row - 1][column - 1 ... column + 1])
        result.append(acres[row][column - 1])
        result.append(acres[row][column + 1])
        result.append(contentsOf: acres[row + 1][column - 1 ... column + 1])
        return result
    }
}
