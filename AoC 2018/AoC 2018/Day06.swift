//
//  Day06.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-06.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

let gridsize = 400

class Day06 {
    
    var points: [Point] = []
    var pointDictionary: [Point:Int] = [:]
    var grid: [[Point?]] = Array<[Point?]>(repeating: Array<Point?>(repeating: nil, count: gridsize), count: gridsize)
    
    let notAPoint = Point(x: 0, y: 0)
    
    func solve () {
        let lines = Utils.readFileLines("Day06.txt")
        for line in lines {
            let tokens = line.components(separatedBy: " ").map { String($0) }
            let point = Point(x: Int(tokens[0].dropLast())!, y: Int(tokens[1])!)
//            print(point)
            points.append(point)
            pointDictionary[point] = 0
//            grid[point.x][point.y] = point
        }
        
        for x in 0 ..< gridsize {
            for y in 0 ..< gridsize {
                let gridPoint = Point(x: x, y: y)
                var closestPoint = gridPoint
                var shortestDistance = gridsize * 2
                for p in pointDictionary.keys {
                    let distance = gridPoint.manhattanDistance(to: p)
                    if distance == shortestDistance {
                        closestPoint = notAPoint
                    }
                    if distance < shortestDistance {
                        closestPoint = p
                        shortestDistance = distance
                    }
                }
                if closestPoint != notAPoint {
                    pointDictionary[closestPoint]! += 1
                }
                grid[x][y] = closestPoint
            }
        }
        
        pointDictionary[notAPoint] = 0
        for i in 0 ..< gridsize {
            removePoint(grid[i][0]!)
            removePoint(grid[i][gridsize - 1]!)
            removePoint(grid[0][i]!)
            removePoint(grid[gridsize - 1][i]!)
        }
        pointDictionary.removeValue(forKey: notAPoint)

        print("Part1: \(pointDictionary.values.sorted().last!)")
        
        var part2 = 0
        for x in 0 ..< gridsize {
            for y in 0 ..< gridsize {
                let gridPoint = Point(x: x, y: y)
                var totalDistance = 0
                for p in pointDictionary.keys {
                    totalDistance += gridPoint.manhattanDistance(to: p)
                }
                if totalDistance < 10000 {
                    part2 += 1
                }
            }
        }

        print("Part2: \(part2)")
    }
    
    func removePoint(_ location: Point) {
        let point = grid[location.x][location.y]!
        if pointDictionary[point] != nil {
            pointDictionary.removeValue(forKey: point)
        }
    }
    
   /*
     155002 is too high
 */
}
