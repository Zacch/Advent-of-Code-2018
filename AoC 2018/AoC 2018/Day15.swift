//
//  Day15.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-15.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Unit {
    var hitPoints = 200
    var attackPower = 3

    let isElf: Bool
    var isGoblin: Bool { get { return !isElf } }

    var pos: Point
    var x: Int { get { return pos.x } }
    var y: Int { get { return pos.y } }

    init(_ x: Int, _ y: Int, isElf: Bool) {
        self.isElf = isElf
        pos = Point(x: x, y: y)
    }
    
    func stats() -> String {
        return "\(isElf ? "E": "G")(\(hitPoints))"
    }
}

class Day15 {
    
    var cavern: [[Bool]] = [[]] // True if wall
    var height = 0
    var width = 0
    
    var startingElves: [Unit] = []
    var startingGoblins: [Unit] = []
    
    var elves: [Unit] = []
    var goblins: [Unit] = []
    
    func solve () {
        let lines = Utils.readFileLines("Day15.txt")
        height = lines.count
        width = lines[0].count
        cavern = Array<[Bool]>(repeating: Array<Bool>(repeating: false, count: width), count: height)
        for y in 0 ..< height {
            let line = lines[y]
            for x in 0 ..< width {
                let char = line[line.index(line.startIndex, offsetBy: x)]
                switch char {
                case "#":
                    cavern[x][y] = true
                case "E":
                    startingElves.append(Unit(x, y, isElf: true))
                case "G":
                    startingGoblins.append(Unit(x, y, isElf: false))
                default:
                    Utils.nop()
                }
            }
        }
        
        let turn = fight(elfPower: 3, stopOnElfDeath: false)
        printCavern()

        var score = 0
        if goblins.isEmpty {
            print("\nThe elves won after \(turn) turns!")
            score = turn * elves.reduce(0, { $0 + $1.hitPoints})
        } else {
            print("\nThe goblins won after \(turn) turns!")
            score = turn * goblins.reduce(0, { $0 + $1.hitPoints})
        }
        print("Part1: \(score)")
        
        print("Part2: \(part2())")
    }


    fileprivate func fight(elfPower: Int, stopOnElfDeath: Bool) -> Int {
        elves = []
        startingElves.forEach { elf in
            let newElf = Unit(elf.x, elf.y, isElf: true)
            newElf.attackPower = elfPower
            elves.append(newElf)
        }
 
        goblins = []
        startingGoblins.forEach { goblin in
            goblins.append(Unit(goblin.x, goblin.y, isElf: false))
        }
        
        var done = false
        var turn = 0
        while !done {
            var units: [Unit] = []
            units.append(contentsOf: elves)
            units.append(contentsOf: goblins)
            units = units.sorted(by: { $0.y < $1.y || ($0.y == $1.y && $0.x < $1.x) })
            for unit in units {
                if unit.hitPoints <= 0 {
                    continue
                }
                if unit.isElf && goblins.isEmpty ||
                    unit.isGoblin && elves.isEmpty {
                    done = true
                    break
                }
                move(unit)
                let elfDeath = attack(with: unit)
                if elfDeath && stopOnElfDeath {
                    return -1
                }
            }
            if !done {
                turn += 1
            }
        }
        return turn
    }

    fileprivate func part2() -> Int {
        var power = 4
        var done = false
        var score = 0
        while !done {
            print("Trying with elf power \(power)")
            let turn = fight(elfPower: power, stopOnElfDeath: true)
            if turn < 0 {
                power += 1
            } else {
                print("\nWith power \(power), the elves win after \(turn) rounds.")
                score = turn * elves.reduce(0, { $0 + $1.hitPoints})
                done = true
            }
        }
        return score
    }
    

    func move(_ unit: Unit) {
        let enemies = enemiesOf(unit)
        if enemies.contains(where: { $0.pos.isAdjacent(to: unit.pos) }) {
            return
        }
        guard let target = findNearestTargetPos(unit) else {
            return
        }

        // Take first step toward target
        let p = firstStep(for: unit, towards: target)
        unit.pos = p
    }

    func attack(with unit: Unit) -> Bool {
        let enemiesInRange = enemiesOf(unit).filter { $0.pos.isAdjacent(to: unit.pos) }
        if enemiesInRange.isEmpty {
            return false
        }
        let minHP = enemiesInRange.map {$0.hitPoints}.min()!
        if let target = enemiesInRange.filter({ $0.hitPoints == minHP }).sorted(by: { $0.y < $1.y || ($0.y == $1.y && $0.x < $1.x) }).first {
            target.hitPoints -= unit.attackPower
            if target.hitPoints <= 0 {
                if target.isElf {
                    elves = elves.filter {$0.pos != target.pos}
                    return true
                } else {
                    goblins = goblins.filter {$0.pos != target.pos}
                }
            }
        }
        return false
    }

    //------------------
    func findNearestTargetPos(_ unit: Unit) -> Point? {
        var targets:[Point] = []
        var pointsToSearch:[Point] = [unit.pos]
        var visited:[Point] = [unit.pos]
        while targets.isEmpty && !pointsToSearch.isEmpty {
            (targets, pointsToSearch, visited) = findTargetPoints(unit, pointsToSearch, visited)
        }
        return targets.sorted(by: { $0.y < $1.y || ($0.y == $1.y && $0.x < $1.x) }).first
    }

    func findTargetPoints(_ unit: Unit, _ pointsToSearch: [Point], _ visitedBefore: [Point]) -> ([Point], [Point], [Point]) {
        var targets:[Point] = []
        var visited:[Point] = []
        var newPointsToSearch: [Point] = []
        visited.append(contentsOf: visitedBefore)
        let enemies = enemiesOf(unit)
        
        for point in pointsToSearch {
            let neighbouringPoints = [Point](arrayLiteral: point.up(), point.left(), point.right(), point.down())
            for p in neighbouringPoints {
                if visited.contains(p) {
                    continue
                }
                if isFree(p) {
                    if enemies.contains(where: { $0.pos.isAdjacent(to: p) }) {
                        targets.append(p)
                    } else {
                        newPointsToSearch.append(p)
                    }
                }
                visited.append(p)
            }
        }
        return (targets, newPointsToSearch, visited)
    }

    //---------------
    func firstStep(for unit: Unit, towards target: Point) -> Point {

        if unit.pos.isAdjacent(to: target) {
            return target
        }
        var firstSteps:[Point] = []
        var pointsToSearch:[Point] = [target]
        var visited:[Point] = [target]
        while firstSteps.isEmpty {
            (firstSteps, pointsToSearch, visited) = findFirstSteps(from: unit, to: target, pointsToSearch, visited)
        }

        return firstSteps.sorted(by: { $0.y < $1.y || ($0.y == $1.y && $0.x < $1.x) }).first!
    }
    
    func findFirstSteps(from unit: Unit, to target: Point, _ pointsToSearch: [Point], _ visitedBefore: [Point]) -> ([Point], [Point], [Point]) {
        var firstSteps:[Point] = []
        var visited:[Point] = []
        var newPointsToSearch: [Point] = []
        visited.append(contentsOf: visitedBefore)
        
        for point in pointsToSearch {
            let neighbouringPoints = [Point](arrayLiteral: point.up(), point.left(), point.right(), point.down())
            for p in neighbouringPoints {
                if visited.contains(p) {
                    continue
                }
                if isFree(p) {
                    if unit.pos.isAdjacent(to: p) {
                        firstSteps.append(p)
                    } else {
                        newPointsToSearch.append(p)
                    }
                }
                visited.append(p)
            }
        }
        return (firstSteps, newPointsToSearch, visited)
    }
    
    func enemiesOf(_ unit: Unit) -> [Unit] {
        return unit.isElf ? goblins : elves
    }

    func contentsOf(_ x:Int, _ y: Int) -> Character {
        if elves.contains(where: { $0.x == x && $0.y == y }) {
            return "E"
        }
        if goblins.contains(where: { $0.x == x && $0.y == y }) {
            return "G"
        }
        return cavern[x][y] ? "#": "."
    }
    
    func isFree(_ point: Point) -> Bool {
        return contentsOf(point.x, point.y) == "."
    }

    func printCavern() {
        var units: [Unit] = []
        units.append(contentsOf: elves)
        units.append(contentsOf: goblins)
        units = units.sorted(by: { $0.y < $1.y || ($0.y == $1.y && $0.x < $1.x) })

        for y in 0 ..< height {
            var line = ""
            for x in 0 ..< width {
                line.append(contentsOf(x, y))
            }
            for unit in units.filter({$0.y == y}) {
                line.append(" \(unit.stats())")
            }
            print(line)
        }
    }
}
