//
//  Day03.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-02.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Claim {
    //    #1252 @ 684,809: 15x13
    let id: Int
    let origin: Point
    let extent: Point
    
    init(_ line: String) {
        let tokens = line.components(separatedBy: " ")
        id = Int(tokens[0].dropFirst())!
        let originParts = tokens[2].components(separatedBy: ",")
        origin = Point(x: Int(originParts[0])!,y: Int(originParts[1].dropLast())!)
        let extentParts = tokens[3].components(separatedBy: "x")
        extent = Point(x: Int(extentParts[0])!,y: Int(extentParts[1])!)
    }
}

class Day03 {
    var claims: [Claim] = []
    var fabric: [Int:[Int]] = [:]
    func solve () {
        let lines = Utils.readFileLines("Day03.txt")
        for line in lines {
            claims.append(Claim(line))
        }
        for i in 0..<1000 {
            fabric[i] = [Int](repeating: 0, count: 1000)
        }
        
        for claim in claims {
            for x in claim.origin.x ..< claim.origin.x + claim.extent.x {
                for y in claim.origin.y ..< claim.origin.y + claim.extent.y {
                    fabric[y]![x] += 1
                }
            }
        }
        var overlaps = 0
        for row in fabric.values {
            overlaps += row.filter {$0 > 1}.count
        }
        print("Part1: \(overlaps)")
        
        var part2: Claim?
        for claim in claims {
            var overlap = false
            for x in claim.origin.x ..< claim.origin.x + claim.extent.x {
                for y in claim.origin.y ..< claim.origin.y + claim.extent.y {
                    if fabric[y]![x] > 1 {
                        overlap = true
                        break
                    }
                }
            }
            if !overlap {
                part2 = claim
                break
            }
        }
        print("Part2: \(part2!.id)")
    }
}
