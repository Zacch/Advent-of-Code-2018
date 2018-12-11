//
//  Day11.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-11.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

    // 9221
class Day11 {
    let input = 9221

    var cells:[[Int]] = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: 301), count: 301)
    
    func solve() {
        for x in 1 ... 300 {
            for y in 1 ... 300 {
                cells[x][y] = power(Point(x: x, y: y))
            }
        }
        let (part1cell, _) = fullestCell(3)
        print("Part 1: \(part1cell.x),\(part1cell.y)")
        
        var part2Cell = Point(x: 0, y: 0)
        var biggestSize = 0
        var highestFuelLevel = 0
        
        for x in 1 ..< 300 {
            print(300 - x)
            for y in 1 ..< 300 {
                let p = Point(x: x, y: y)
                let (size, fuel) = bestSize(p)
                if fuel > highestFuelLevel {
                    highestFuelLevel = fuel
                    part2Cell = p
                    biggestSize = size
                }
            }
        }
        print("Part 2: \(part2Cell.x),\(part2Cell.y),\(biggestSize))")
    }
    
    func fullestCell(_ size: Int) -> (Point, Int) {
        var bestCell = Point(x: 0, y: 0)
        var highestFuelLevel = 0
        for x in 1 ... 300 - size {
            for y in 1 ... 300 - size {
                let p = Point(x: x, y: y)
                let fuel = squarePower(p, size)
                if fuel > highestFuelLevel {
                    highestFuelLevel = fuel
                    bestCell = p
                }
            }
        }
        return (bestCell, highestFuelLevel)
    }
    
    func bestSize(_ p: Point) -> (Int, Int) {
        var highestFuelLevel = 0
        var bestSize = 0
        var fuel = cells[p.x][p.y]
        let maxSize = 300 - max(p.x, p.y)
        if maxSize == 1 {
            return (bestSize, highestFuelLevel)
        }

        for size in 1 ... maxSize {
            for i in 0 ..< size {
                fuel += cells[p.x + size][p.y + i] + cells[p.x + i][p.y + size]
            }
            fuel += cells[p.x + size][p.y + size]
            if fuel > highestFuelLevel {
                highestFuelLevel = fuel
                bestSize = size
            }
        }
        return (bestSize + 1, highestFuelLevel)
    }

    func squarePower(_ topLeft: Point, _ size: Int) -> Int {
        var totalPower = 0
        for x in topLeft.x ..< topLeft.x + size {
            for y in topLeft.y ..< topLeft.y + size {
                totalPower += cells[x][y]
            }
        }
        return totalPower
    }

    func power(_ cell: Point) -> Int {
        let rackId = cell.x + 10
        let power = (rackId * cell.y + input) * rackId
        let hundreds = power % 1000 - power % 100
        return (hundreds/100) - 5
    }
}
