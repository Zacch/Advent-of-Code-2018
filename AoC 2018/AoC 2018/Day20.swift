//
//  Day20.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-20.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Room {
    static var no = 1
    let number: Int
    var n = false, e = false, s = false, w = false
    init() {
        number = Room.no
        Room.no += 1
    }
}

class Day20 {
    
    var map: [[Room]] = [[Room()]]
    var mapSize = 0
    var arraySize: Int { get { return mapSize * 2 + 1 } }
    func solve () {
        // let line = Utils.readFile("Day20.txt")
        
        let line = "^WNE$"
        // print(line)
        traceRoute(String(line.dropFirst().dropLast()))
        printMap()
        print("Part1: ")
        print("Part2: ")
    }

    func traceRoute(_ route: String) {
        var location: Point = Point(x: 0, y: 0)
        location = traceRoute(route, from: location)
        print(location)
    }
    func traceRoute(_ route: String, from p: Point) -> Point {
        print(route)
        var x = p.x, y = p.y
        route.forEach { c in
            switch c {
            case "N":
                roomAt(x, y).n = true
                y -= 1
                roomAt(x, y).s = true
            case "E":
                roomAt(x, y).e = true
                x += 1
                roomAt(x, y).w = true
            case "S":
                roomAt(x, y).s = true
                y += 1
                roomAt(x, y).n = true
            case "W":
                roomAt(x, y).w = true
                x -= 1
                roomAt(x, y).e = true
            default:
                error()
            }
        }
        return Point(x: x, y: y)
    }
    
    func roomAt(_ x:Int, _ y:Int) -> Room {
        while y < -mapSize || y > mapSize ||
              x < -mapSize || x > mapSize {
            growMap()
        }
        return map[y + mapSize][x + mapSize]
    }
    
    func growMap() {
        mapSize += 1
        var newMap: [[Room]] = []
        var firstRow: [Room] = []
        var lastRow: [Room] = []
        for _ in 0 ..< arraySize {
            firstRow.append(Room())
            lastRow.append(Room())
        }
        newMap.append(firstRow)
        for row in 0 ..< arraySize - 2 {
            var newRow: [Room] = []
            newRow.append(Room())
            newRow.append(contentsOf: map[row])
            newRow.append(Room())
            newMap.append(newRow)
        }
        newMap.append(lastRow)
        map = newMap
    }
    
    func printMap() {
        
        print(String(Array<Character>(repeating: "#", count: arraySize * 2 + 1)))
        map.forEach { row in
            var line = "#"
            line.append(row.map{ String($0.number) + String($0.e ? "|" : "#") }.reduce("", +))
            print(line)
            line = "#"
            line.append(row.map{ String($0.s ? "-" : "#") + "#" }.reduce("", +))
            print(line)
        }
        print("---")

    }

    func error() {
        print("Error")
    }
}
