//
//  Day10.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-10.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation
import CoreGraphics

class Light {
    let start: Point
    let v: Point
    
    init(_ startPos: Point, velocity: Point) {
        start = startPos
        v = velocity
    }
    
    func posAfter(_ t: Int) -> Point {
        return Point(x: start.x + t * v.x, y: start.y + t * v.y)
    }
}

class Day10 {
    
    var lights: [Light] = []
    
    func solve () {
        let lines = Utils.readFileLines("Day10.txt")
        for line in lines {
            let tokens = line.components(separatedBy: "=").map { String($0) }
            let t2 = tokens[1].components(separatedBy: ">").map { String($0) }
            let t3 = t2[0].components(separatedBy: ",").map { String($0) }
            let start = Point(x: Int(t3[0].dropFirst().trimmingCharacters(in: .whitespaces))!,
                              y: Int(t3[1].trimmingCharacters(in: .whitespaces))!)
            let t4 = tokens[2].components(separatedBy: ",").map { String($0) }
            let v = Point(x: Int(t4[0].dropFirst().trimmingCharacters(in: .whitespaces))!,
                              y: Int(t4[1].dropLast().trimmingCharacters(in: .whitespaces))!)
            let light = Light(start, velocity: v)
            lights.append(light)
        }
        let origin = Point(x: 0, y: 0)
        
        var lastDistance = 999999
        var time = 0
        for i in 0 ... 15000 {
            let points = lights.map { $0.posAfter(i) }
            let maxDist = points.map {$0.manhattanDistance(to: origin)}.max()!
            if maxDist > lastDistance {
                break
            }
            time = i
            lastDistance = maxDist
        }

        let points = lights.map { $0.posAfter(time) }

        
        
        print("Part1: ")
        drawImage(points)
        print("Part2: \(time)")
    }
   

    func drawImage(_ pixels:[Point]) {
        let min = Point(x: pixels.map{ $0.x }.min()!, y: pixels.map{ $0.y }.min()!)
        let max = Point(x: pixels.map{ $0.x }.max()!, y: pixels.map{ $0.y }.max()!)
        
        let width = max.x - min.x
        let height = max.y - min.y
        
        var data: [Character] = Array<Character>(repeating: " ", count: (width + 4) * (height + 4))
        for p in pixels {
            let x =  p.x - min.x + 2
            let y = p.y - min.y + 2
            data[y * (width + 4) + x] = "*"
        }
        print()
        for y in 0 ..< height + 4 {
            var line = ""
            for x in 0 ..< width + 4 {
                line.append(data[y * (width + 4) + x])
            }
            print(line)
        }
    }
}
