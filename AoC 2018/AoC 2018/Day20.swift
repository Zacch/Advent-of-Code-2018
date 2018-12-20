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


class RegexNode {
    let content: String
    var parent: RegexNode? = nil
    var children: [RegexNode] = []
    
    init(_ string: String) { content = string }
    init(_ substring: Substring) { content = String(substring) }
    init() { content = "" }
    
    func add(child: RegexNode) -> RegexNode {
        child.parent = self
        children.append(child)
        return child
    }
}

class Day20 {
    var map: [[Room]] = [[Room()]]
    var mapSize = 0
    var arraySize: Int { get { return mapSize * 2 + 1 } }
    
    func solve () {
        // let line = Utils.readFile("Day20.txt")
        
        // print(line)
//        let root = parse("ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN")
        let root = parse("ENWWW(NEEE|SSE(EE|N))")
        print("---")
        printVariants(root).forEach {print($0)}
//        traceRoute(String(line.dropFirst().dropLast()))
//        printMap()
//        print("Part1: ")
//        print("Part2: ")
    }

    func parse(_ input: String) -> RegexNode {
        print(input)
        let root = RegexNode()
        var currentString = ""
        var currentGroup: RegexNode = root
        var lastChar: Character = "?"
        for char in input {
            switch char {
            case "(":
                currentGroup = currentGroup.add(child: RegexNode(currentString))
                currentString = ""
            case "|":
                currentGroup.children.append(RegexNode(currentString))
                currentString = ""
            case ")":
                if currentString.isEmpty {
                    if lastChar == "|" {
                        currentGroup.children.append(RegexNode(""))
                    }
                } else {
                    currentGroup.children.append(RegexNode(currentString))
                    currentString = ""
                }
                currentGroup = currentGroup.parent!
            default:
                currentString.append(char)
            }
            lastChar = char
        }
        if !currentString.isEmpty {
            currentGroup.children.append(RegexNode(currentString)) // Hmm...?
        }

        return root.children.count == 1 ? root.children[0] :  root
    }

    
    // Does not yet work :P
    func printVariants(_ root:  RegexNode) -> [String] {
        if root.children.isEmpty {
            return [root.content]
        }
        
        var result: [String] = [root.content]
        root.children.forEach {child in
            let strings = printVariants(child)
            var newResult: [String] = []
            result.forEach { s in
                strings.forEach { newResult.append(s + $0) }
            }
            result = newResult
        }
        return result
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
