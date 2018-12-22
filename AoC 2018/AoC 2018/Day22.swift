//
//  Day22.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-22.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day22 {
    
//    depth: 11541
//    target: 14,778

//    let depth = 510 // 11541
//    var width = 11  // 15
//    var height = 11 // 779
//    let target = Point(x: 10, y: 10)

    let depth = 11541
    var width = 15
    var height = 779
    let target = Point(x: 14, y: 778)

    var geoIndex:[[Int]] = []
    var erosion:[[Int]] = []

    var visited: [[CaveLocation?]] = []

    
    func fillArrays() {
        geoIndex = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: height), count: width)
        erosion  = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: height), count: width)
        for x in 0 ..< width {
            geoIndex[x][0] = x * 16807
            erosion[x][0] = (geoIndex[x][0] + depth) % 20183
        }
        for y in 0 ..< height {
            geoIndex[0][y] = y * 48271
            erosion[0][y] = (geoIndex[0][y] + depth) % 20183
        }
        for x in 1 ..< width {
            for y in 1 ..< height {
                if x == target.x && y == target.y {
                    geoIndex[x][y] = 0
                    erosion[x][y] = depth % 20183
                } else {
                    geoIndex[x][y] = erosion[x - 1][y] * erosion[x][y - 1]
                    erosion[x][y] = (geoIndex[x][y] + depth) % 20183
                }
            }
        }
        
        if visited.isEmpty {
            visited = Array<[CaveLocation?]>(repeating: Array<CaveLocation?>(repeating: nil, count: height), count: width)
        }
    }
    
    func growArrays() {
        var newVisited: [[CaveLocation?]] = []
        newVisited.append(contentsOf: visited)
        for i in 0 ..< width {
            newVisited[i].append(contentsOf: Array<CaveLocation?>(repeating: nil, count: 5))
        }
        newVisited.append(contentsOf:
            Array<[CaveLocation?]>(repeating: Array<CaveLocation?>(repeating: nil, count: height + 5), count: 5))
        visited = newVisited
        width += 5
        height += 5
        fillArrays()
    }

    fileprivate func printPath(_ current: CaveLocation) {
        var path = current.path
        path.append(current)
        printCave(path)
        
        path.forEach { region in
            var type = " "
            switch regionType(of: region.coords) {
            case .rocky:
                type = "."
            case .wet:
                type = "="
            case .narrow:
                type = "|"
            }
            print("\(type) \(region))")
        }
    }
    
    func solve() {
        fillArrays()

        print("Part 1: \(riskLevel())")
        let current = part2()
        print("Part 2: \(current.time)")
    }
    
    func printCave(_ path:[CaveLocation] = []) {
        for row in 0 ..< height {
            var line = ""
            for column in 0 ..< width {
                if path.contains(where: { $0.coords == Point(x: column, y: row) }) {
                    line += visited[column][row] == nil ? "!" : "*"
                } else {
                    line += visited[column][row] == nil ? " " : "_"
                }
                switch erosion[column][row] % 3 {
                case 0:
                    line += "."
                case 1:
                    line += "="
                case 2:
                    line += "|"
                default:
                    print("error")
                }
            }
            print(line)
        }
    }
    func riskLevel() -> Int {
        var risk = 0
        for x in 0 ..< width {
            for y in 0 ..< height {
                risk += erosion[x][y] % 3
            }
        }
        return risk
    }
    
    // A* search
    func part2() -> CaveLocation {
        let origin = CaveLocation(Point(x: 0, y: 0), tools: [.torch], path: [],
                                  time: 0, distanceToGoal: target.x + target.y)
        var frontier = PriorityQueue<CaveLocation>(ascending: true, startingValues: [origin])

        while let current = frontier.pop() {
//            if current.coords == Point(x: 4, y: 2) {
//                printCave(current.path)
//            }
            if current.coords == target {
                if !current.tools.contains(.torch) {
                    current.tools = [.torch]
                    current.time += 7
                    frontier.push(current)
                    continue
                }
//                printPath(current)
//                for c in frontier.filter({ $0.coords == target }) {
//                    printPath(c)
//                }
                return current
            }
            let neighbours = neighboursOf(current)
            for next in neighbours {
                let p = next.coords
//                if p == Point(x: 4, y: 2) {
//                    printCave(next.path)
//                }

                if visited[p.x][p.y] == nil || next.time < visited[p.x][p.y]!.time {
                    visited[p.x][p.y] = next
                    frontier.push(next)
                } else if let old = visited[p.x][p.y],
                    next.time == old.time,
                    !next.tools.filter({!old.tools.contains($0)}).isEmpty {
                    frontier.push(next)
                }

            }
        }
        return origin
    }
    
    // 1085 is too high
    
    func neighboursOf(_ current: CaveLocation) -> [CaveLocation] {
        var result: [CaveLocation] = []
        let p = current.coords
        
        if p.x + 1 >= width || p.y + 1 >= height {
            growArrays()
        }
        var neighbours: [Point] = [Point(x: p.x + 1, y: p.y), Point(x: p.x, y: p.y + 1)]
        if p.x > 0 {
            neighbours.append(Point(x: p.x - 1, y: p.y))
        }
        if p.y > 0 {
            neighbours.append(Point(x: p.x, y: p.y - 1))
        }
        for n in neighbours {
            var time = current.time + 1
            var tools = current.tools
            var validTools: [Tool]
            switch regionType(of: current.coords) {
            case .rocky:
                validTools = [.torch, .climbingGear]
            case .wet:
                validTools = [.none, .climbingGear]
            case .narrow:
                validTools = [.none, .torch]
            }

            switch regionType(of: n) {
            case .rocky:
                tools = tools.filter { $0 != .none }
                if tools.isEmpty {
                    time += 7
                    tools = [.torch, .climbingGear].filter { validTools.contains($0) }
                }
            case .wet:
                tools = tools.filter { $0 != .torch }
                if tools.isEmpty {
                    time += 7
                    tools = [.none, .climbingGear].filter { validTools.contains($0) }
                }
            case .narrow:
                tools = tools.filter { $0 != .climbingGear }
                if tools.isEmpty {
                    time += 7
                    tools = [.none, .torch].filter { validTools.contains($0) }
                }
            }
            var path = current.path
            path.append(current)
            result.append(CaveLocation(n, tools: tools, path: path, time: time,
                                       distanceToGoal: target.manhattanDistance(to: n)))
        }
        return result
    }
    
    func regionType(of region: Point) -> RegionType {
        switch erosion[region.x][region.y] % 3 {
        case 0:
            return .rocky
        case 1:
            return .wet
        case 2:
            return .narrow
        default:
            print("error")
            return .rocky
        }
    }
}

enum RegionType {
    case rocky
    case wet
    case narrow
}

enum Tool {
    case none
    case torch
    case climbingGear
}

class CaveLocation: NSObject, Comparable {
    let coords: Point
    var tools: [Tool]
    var path: [CaveLocation]

    var time: Int
    let distanceToGoal: Int
    var priority: Int { get { return time + distanceToGoal } }

    init(_ coords: Point, tools: [Tool], path: [CaveLocation], time: Int, distanceToGoal: Int) {
        self.coords = coords
        self.tools = tools
        self.path = path
        self.time = time
        self.distanceToGoal = distanceToGoal
    }

    static func < (lhs: CaveLocation, rhs: CaveLocation) -> Bool {
        return lhs.priority < rhs.priority
    }
    
    static func == (lhs: CaveLocation, rhs: CaveLocation) -> Bool {
        return lhs.coords == rhs.coords
    }
    
    
    override public var description: String {
        return "\(coords) \(tools), prio \(priority), time \(time), dist \(distanceToGoal)"
    }
    override var debugDescription: String {
        return description
    }
}
