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

//    let depth = 510
//    let target = Point(x: 10, y: 10)

    let depth = 11541
    let target = Point(x: 14, y: 778)

    var arrayWidth: Int
    var arrayHeight: Int

    var geoIndex:[[Int]] = []
    var erosion:[[Int]] = []

    var visited: [[CaveLocation?]] = []

    init() {
//        arrayWidth = target.x + 1
//        arrayHeight = target.y + 1
        arrayWidth = 160
        arrayHeight = 924
        fillArrays()
    }
    
    func solve() {
        print("Part 1: \(riskLevel())")
        let path = fastestPath()
        print("Part 2: \(path.time)")
        printCave(path)
        printPath(path)
//        print(arrayWidth, arrayHeight)
    }
    // Part 1: 11575 is correct
    // Part 2: 1085 is too high

    func riskLevel() -> Int {
        var risk = 0
        for x in 0 ... target.x {
            for y in 0 ... target.y {
                risk += erosion[x][y] % 3
            }
        }
        return risk
    }
    
    // A* search with variations
    func fastestPath() -> CaveLocation {
        let origin = CaveLocation(Point(x: 0, y: 0), tool: .torch, path: [],
                                  time: 0, distanceToGoal: target.x + target.y)
        let frontier = PriorityQueue<CaveLocation>()
        frontier.push(origin, prio: origin.priority)
        visited[0][0] = origin

        while let current = frontier.pop() {
            if current.coords == target {
                if !(current.tool == .torch) {
                    current.tool = .torch
                    current.time += 7
                    frontier.push(current, prio: current.priority)
                    continue
                }
                return current
            }
            let neighbours = neighboursOf(current)
            for next in neighbours {
                let p = next.coords

                if visited[p.x][p.y] == nil || next.time < visited[p.x][p.y]!.time {
                    visited[p.x][p.y] = next
                    frontier.push(next, prio: next.priority)
                } else if let old = visited[p.x][p.y],
                    next.time == old.time,
                    next.tool != old.tool {
                    frontier.push(next, prio: next.priority)
                }
            }
        }
        return origin
    }
    
    func neighboursOf(_ current: CaveLocation) -> [CaveLocation] {
        var result: [CaveLocation] = []
        let p = current.coords
        
        if p.x + 1 >= arrayWidth || p.y + 1 >= arrayHeight {
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
            var tool = current.tool
            let currentType = regionType(of: current.coords)

            var newTool: Tool?
            switch regionType(of: n) {
            case .rocky:
                if tool == .noTools {
                    newTool = (currentType == .wet ? .climbingGear : .torch)
                }
            case .wet:
                if tool == .torch {
                    newTool = (currentType == .rocky ? .climbingGear : .noTools)
                }
            case .narrow:
                if tool == .climbingGear {
                    newTool = (currentType == .rocky ? .torch : .noTools)
                }
            }

            if newTool != nil {
                time += 7
                tool = newTool!
            }

            var path = current.path
            path.append(current)
            result.append(CaveLocation(n, tool: tool, path: path, time: time,
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
    
    func fillArrays() {
        geoIndex = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: arrayHeight), count: arrayWidth)
        erosion  = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: arrayHeight), count: arrayWidth)
        for x in 0 ..< arrayWidth {
            geoIndex[x][0] = x * 16807
            erosion[x][0] = (geoIndex[x][0] + depth) % 20183
        }
        for y in 0 ..< arrayHeight {
            geoIndex[0][y] = y * 48271
            erosion[0][y] = (geoIndex[0][y] + depth) % 20183
        }
        for x in 1 ..< arrayWidth {
            for y in 1 ..< arrayHeight {
                if x == target.x && y == target.y {
                    geoIndex[x][y] = 0
                } else {
                    geoIndex[x][y] = erosion[x - 1][y] * erosion[x][y - 1]
                }
                erosion[x][y] = (geoIndex[x][y] + depth) % 20183
            }
        }
        
        if visited.isEmpty {
            visited = Array<[CaveLocation?]>(repeating: Array<CaveLocation?>(repeating: nil, count: arrayHeight), count: arrayWidth)
        }
    }
    
    func growArrays() {
        var newVisited: [[CaveLocation?]] = []
        newVisited.append(contentsOf: visited)
        for i in 0 ..< arrayWidth {
            newVisited[i].append(contentsOf: Array<CaveLocation?>(repeating: nil, count: 5))
        }
        newVisited.append(contentsOf:
            Array<[CaveLocation?]>(repeating: Array<CaveLocation?>(repeating: nil, count: arrayHeight + 5), count: 5))
        visited = newVisited
        arrayWidth += 5
        arrayHeight += 5
        fillArrays()
    }
    
    fileprivate func printPath(_ current: CaveLocation) {
        var path = current.path
        path.append(current)
        
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

    func printCave(_ location:CaveLocation) {
        var path = location.path
        path.append(location)
        let width = path.map { $0.coords.x }.max()! + 1
        let height = path.map { $0.coords.y }.max()! + 1
        for row in 0 ..< height {
            var line = ""
            for column in 0 ..< width {
                if let location = path.filter({ $0.coords == Point(x: column, y: row) }).first {
                        switch location.tool {
                        case .noTools:
                            line += "N"
                        case .climbingGear:
                            line += "G"
                        case .torch:
                            line += "T"
                        }
                } else {
                    line += visited[column][row] == nil ? " " : " "
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
}

enum RegionType {
    case rocky
    case wet
    case narrow
}

enum Tool {
    case noTools
    case torch
    case climbingGear
}

class CaveLocation: NSObject, Comparable {
    let coords: Point
    var tool: Tool
    var path: [CaveLocation]

    var time: Int
    let distanceToGoal: Int
    var priority: Int { get { return time + distanceToGoal } }

    init(_ coords: Point, tool: Tool, path: [CaveLocation], time: Int, distanceToGoal: Int) {
        self.coords = coords
        self.tool = tool
        self.path = path
        self.time = time
        self.distanceToGoal = distanceToGoal
    }

    static func < (lhs: CaveLocation, rhs: CaveLocation) -> Bool {
        return lhs.priority < rhs.priority
    }
    
    override public var description: String {
        return "\(coords) \(tool), prio \(priority), time \(time), dist \(distanceToGoal)"
    }
    override var debugDescription: String {
        return description
    }
}
