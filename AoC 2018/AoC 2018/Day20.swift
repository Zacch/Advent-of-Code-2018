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
    
    var roomsFarAway: Set<Point> = []
    let farLimit = 1000
    func solve () {
        let line = String(Utils.readFileLines("Day20.txt").first!.dropFirst().dropLast())
        let sequence = parseLine(line)
        let _ = createMap(sequence, from: [Point(x: 0, y: 0)])

        print("Part1: \(furthestRoomDistance())")
        print("Part2: \(roomsFarAway.count)")
    }

    func createMap(_ sequence: PartSequence, from startPoints:[Point]) -> [Point] {
        var endPoints = startPoints
        for part in sequence.parts {
            if let directions = part as? Directions {
                endPoints = createMap(directions, from: endPoints)
            } else {
                endPoints = createMap(part as! Fork, from: endPoints)
            }
        }
        return endPoints
    }

    func createMap(_ fork: Fork, from startPoints: [Point]) -> [Point] {
        var endPoints: [Point] = []
        for sequence in fork.sequences {
            endPoints.append(contentsOf: createMap(sequence, from: startPoints))
        }
        return Array(Set(endPoints))
    }

    func createMap(_ directions: Directions, from startPoints: [Point]) -> [Point] {
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
            if !endPoints.contains(Point(x: x, y: y)) {
                endPoints.append(Point(x: x, y: y))
            }
        }
        return endPoints
    }
    
    func furthestRoomDistance() -> Int {
        var visited: [Path] = []
        var frontier: [Path] = [Path(Point(x: 0, y: 0))]
        
        while !frontier.isEmpty {
            let next = frontier[0]
            frontier.remove(at: 0)
            let room = roomAt(next.end.x, next.end.y)
            var paths: [Path] = []
            if room.n { paths.append(Path(next.end.up())) }
            if room.e { paths.append(Path(next.end.right())) }
            if room.w { paths.append(Path(next.end.left())) }
            if room.s { paths.append(Path(next.end.down())) }
            for path in paths {
                if visited.contains(path) || frontier.contains(path) {
                    continue
                }
                path.rooms = next.rooms
                path.rooms.append(next.end)
                frontier.append(path)
            }
            if next.rooms.count >= farLimit {
                roomsFarAway.insert(next.end)
            }
            if frontier.isEmpty {
                return next.rooms.count
            }
            visited.append(next)
        }
        return 0
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

class Path: NSObject {
    let end: Point
    var rooms: [Point] = []
    init(_ end:Point) {
        self.end = end
    }
    override var hash: Int  { get  { return end.hash }}
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Path else {
            return false
        }
        return self.end == other.end
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
