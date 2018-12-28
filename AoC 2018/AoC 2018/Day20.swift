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
//         let line = String(Utils.readFile("Day20.txt").dropFirst().dropLast())
        let line = "ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN"
//        let line = "ENWWW(NEEE|SSE(EE|N))"
 //       let line = "WNENWNNWWWS"
//        let line = "N(E|W)N(E|W)N"
        let sequence = parseLine(line)

        let _ = traceRoute(sequence, from: [Point(x: 0, y: 0)])
        printMap()
        print("Part1: ")
//        print("Part2: ")
    }

    func traceRoute(_ sequence: PartSequence, from startPoints:[Point]) -> [Point] {
        var locations = startPoints
        for part in sequence.parts {
            if let directions = part as? Directions {
                locations = traceRoute(directions, from: locations)
            } else {
                locations = traceRoute(part as! Fork, from: locations)
            }
        }
        return locations
    }

    func traceRoute(_ fork: Fork, from startPoints: [Point]) -> [Point] {
        var endPoints: [Point] = []
        for sequence in fork.sequences {
            endPoints.append(contentsOf: traceRoute(sequence, from: startPoints))
        }
        return endPoints
    }

    func traceRoute(_ directions: Directions, from startPoints: [Point]) -> [Point] {
        var endPoints: [Point] = []
        for point in startPoints {
            var x = point.x, y = point.y
            for c in directions.s {
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
                    print("ERROR")
                }
            }
            endPoints.append(Point(x: x, y: y))
        }
        return endPoints
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
            line.append(row.map{ " " + String($0.e ? "|" : "#") }.reduce("", +))
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
    
    //    MARK: -
    func parseLine(_ line: String) -> PartSequence {
        var sequence = PartSequence()
        (_, sequence) = parseSequence(Substring(line))
        return sequence
    }
    
    func parseSequence(_ s: Substring) -> (Substring, PartSequence) {
        let sequence = PartSequence()
        var restOfLine = s
        while !restOfLine.isEmpty && !"|)".contains(restOfLine.first!) {
            var part = Part()
            (restOfLine, part) = parsePart(restOfLine)
            sequence.parts.append(part)
        }
        return (restOfLine, sequence)
    }
    
    func parsePart(_ s: Substring) -> (Substring, Part) {
        if s.starts(with: "(") {
            return parseFork(s)
        }
        var i = s.startIndex
        while i < s.endIndex && "NESW".contains(s[i]) {
            i = s.index(after: i)
        }
        let part: Part = Directions(String(s[s.startIndex ..< i]))
        return (s[i ..< s.endIndex], part)
    }
    
    func parseFork(_ s: Substring) -> (Substring, Part) {
        let result: Fork = Fork()
        var restOfLine = s.dropFirst()
        while !restOfLine.starts(with: ")") {
            var sequence: PartSequence
            (restOfLine, sequence) = parseSequence(restOfLine)
            result.sequences.append(sequence)
            if restOfLine.starts(with: "|") {
                restOfLine = restOfLine.dropFirst()
                if restOfLine.starts(with: ")") {
                    result.sequences.append(PartSequence())
                }
            }
        }
        return (restOfLine.dropFirst(), result as Part)
    }
}

class PartSequence: NSObject {
    var parts: [Part] = []
    
    override public var description: String {
        return parts.map {$0.description}.reduce("", +)
    }
}

class Part: NSObject {
}

class Directions: Part {
    let s: String
    
    init(_ directions: String) {
        s = directions
    }
    
    override public var description: String {
        return s
    }
}

class Fork: Part {
    var sequences: [PartSequence] = []
    override public var description: String {
        if sequences.isEmpty {
            return "()"
        }
        var result = "("
        for sequence in sequences {
            result += sequence.description + "|"
        }
        return result.dropLast() + ")"
    }
}
