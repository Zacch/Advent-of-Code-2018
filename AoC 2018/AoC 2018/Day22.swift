//
//  Day22.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-22.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day22 {

    let depth = 11541
    let target = Point(x: 14, y: 778)

    var arrayWidth: Int
    var arrayHeight: Int

    var geoIndex:[[Int]] = []
    var erosion:[[Int]] = []

    init() {
        arrayWidth = target.x + 1
        arrayHeight = target.y + 1
        fillArrays()
    }
    
    func solve() {
        print("Part 1: \(riskLevel())")
        let path = fastestPath()
        print("Part 2: \(path.time)")
//        printCave(path)
//        printPath(path)
    }

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
        var visited: [Point:[CaveLocation]] = [:]

        while let current = frontier.pop() {
            if current.coords == target {
                if current.tool != .torch {
                    let goal = CaveLocation(current.coords, tool: .torch, path: current.path, time: current.time + 7, distanceToGoal: 0)
                    frontier.push(goal, prio: goal.priority)
                    continue
                }
                return current
            }
            let neighbours = neighboursOf(current)
            for next in neighbours {
                if let old = visited[next.coords]?.first(where: { $0.tool == next.tool }) {
                    if old.time > next.time {
                        print("Replacing \(old)")
                        print("     with \(next)")
                        visited[next.coords] = visited[next.coords]!.filter { $0 != next }
                        frontier.push(next, prio: next.priority)
                    }
                } else {
                    frontier.push(next, prio: next.priority)
                }
            }
            if visited[current.coords] == nil {
                visited[current.coords] = [current]
            } else {
                visited[current.coords]!.append(current)
            }
        }
        return origin
    }
    
    func neighboursOf(_ current: CaveLocation) -> [CaveLocation] {
        var result: [CaveLocation] = []
        var newPath = current.path
        newPath.append(current)

        var theOtherTool: Tool
        switch regionType(of: current.coords) {
        case .rocky:
            theOtherTool = (current.tool == .torch ? .climbingGear : .torch)
        case .wet:
            theOtherTool = (current.tool == .noTools ? .climbingGear : .noTools)
        case .narrow:
            theOtherTool = (current.tool == .torch ? .noTools : .torch)
        }
        result.append(CaveLocation(current.coords, tool: theOtherTool, path: newPath, time: current.time + 7, distanceToGoal: current.distanceToGoal))

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
            switch regionType(of: n) {
            case .rocky:
                if current.tool == .noTools { continue }
            case .wet:
                if current.tool == .torch { continue }
            case .narrow:
                if current.tool == .climbingGear { continue }
            }
            result.append(CaveLocation(n, tool: current.tool, path: newPath, time: current.time + 1,
                                       distanceToGoal: n.manhattanDistance(to: target)))
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
    }
    
    func growArrays() {
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
                    line += " "
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

class CaveLocation: NSObject {
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

    override var hash: Int  {
        get {
            switch tool {
            case .noTools:
                return coords.hash
            case .climbingGear:
                return coords.hash + 1 << 61
            case .torch:
                return coords.hash + 1 << 62
            }
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? CaveLocation else {
            return false
        }
        return self.coords == other.coords && self.tool == other.tool
    }
    
    override public var description: String {
        return "\(coords) \(tool), prio \(priority), time \(time), dist \(distanceToGoal)"
    }
    override var debugDescription: String {
        return description
    }
}
