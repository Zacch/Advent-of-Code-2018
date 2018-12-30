//
//  Day24.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-24.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day24 {
    
    var parsedImmunityArmy: [ArmyGroup] = []
    var parsedInfectionArmy: [ArmyGroup] = []
    
    func solve () {
        parseInput()
        print("Part1: \(part1())")
        print("Part2: \(part2())")
    }
    
    func part1() -> Int {
        let (_, winningArmy) = battle(immuneBoost: 0)
        return winningArmy.map { $0.units }.reduce(0, +)
    }

    func part2() -> Int {
        var low = 0
        var high = 65536
        var win: Bool = false
        var winningArmy: [ArmyGroup] = []
        while low + 1 < high {
            let middle = (low + high) / 2
            (win, winningArmy) = battle(immuneBoost: middle)
            if win {
                high = middle
            } else {
                low = middle
            }
        }
        if !win {
            (_, winningArmy) = battle(immuneBoost: high)
        }
        return winningArmy.map { $0.units }.reduce(0, +)
    }

    func battle(immuneBoost: Int) -> (Bool, [ArmyGroup]) {
        var immunityArmy = parsedImmunityArmy.map { $0.copy(boost: immuneBoost) }
        var infectionArmy = parsedInfectionArmy.map { $0.copy(boost: 0) }
        
        while !immunityArmy.isEmpty && !infectionArmy.isEmpty {

            // Target selection
            var groupsInSelectOrder = Array(infectionArmy).sorted { g1, g2 in
                return g1.effectivePower > g2.effectivePower ||
                    (g1.effectivePower == g2.effectivePower && g1.initiative > g2.initiative)
            }
            groupsInSelectOrder.append(contentsOf: immunityArmy.sorted { g1, g2 in
                return g1.effectivePower > g2.effectivePower ||
                    (g1.effectivePower == g2.effectivePower && g1.initiative > g2.initiative)
            })

            groupsInSelectOrder.forEach { $0.target = nil; $0.isTargeted = false }
            for attacker in groupsInSelectOrder {
                let enemies = attacker.isImmunity ? infectionArmy : immunityArmy
                let filteredEnemies = enemies.filter({ !$0.isTargeted && damage(by: attacker, on: $0) > 0 })

                let sortedEnemies = filteredEnemies.sorted(by: { g1, g2 in
                    let d1 = damage(by: attacker, on: g1)
                    let d2 = damage(by: attacker, on: g2)
                    return d1 > d2 ||
                        (d1 == d2 && g1.effectivePower > g2.effectivePower) ||
                        (d1 == d2 && g1.effectivePower == g2.effectivePower && g1.initiative > g2.initiative)
                })
                if let target = sortedEnemies.first {
                    target.isTargeted = true
                    attacker.target = target
                }
            }
            
            // Attacking
            var groupsInAttackOrder = Array(immunityArmy)
            groupsInAttackOrder.append(contentsOf: infectionArmy)
            groupsInAttackOrder = groupsInAttackOrder.sorted { $0.initiative > $1.initiative }
            var stalemate = true
            for attacker in groupsInAttackOrder {
                if let target = attacker.target,
                   attacker.units > 0 {
                    let hit = damage(by: attacker, on: target)
                    let unitsLost = min(target.units, hit / target.hitPointsPerUnit)
                    if unitsLost > 0 {
                        stalemate = false
                    }
                    target.units -= unitsLost
                }
            }
            if stalemate {
                // Assume the infection wins stalemates, since we are looking
                // for the smallest boost that lets the immune system win.
                return (false, [])
            }

            immunityArmy = immunityArmy.filter { $0.units > 0 }
            infectionArmy = infectionArmy.filter { $0.units > 0 }
        }
        return immunityArmy.isEmpty ? (false, infectionArmy) : (true, immunityArmy)
    }
        
    
    func damage(by attacker: ArmyGroup, on target: ArmyGroup) -> Int {
        if target.immunities.contains(attacker.attackType) {
            return 0
        }
        if target.weaknesses.contains(attacker.attackType) {
            return attacker.effectivePower * 2
        }
        return attacker.effectivePower
    }
    
    fileprivate func parseInput() {
        let lines = Utils.readFileLines("Day24.txt")
        var parsingImmunityArmy = false
        var nextId = 0
        for line in lines {
            let tokens = line.components(separatedBy: " ").map { String($0) }
            if tokens[0] == "Immune" {
                parsingImmunityArmy = true
                nextId = 1
                continue
            }
            if tokens[0] == "Infection:" {
                parsingImmunityArmy = false
                nextId = 1
                continue
            }
            let group = ArmyGroup()
            group.id = nextId
            nextId += 1
            group.isImmunity = parsingImmunityArmy
            let ints = Utils.getIntegers(line)
            group.units = ints[0]
            group.hitPointsPerUnit = ints[1]
            group.damage = ints[2]
            group.initiative = ints[3]

            var index = 9
            if tokens[7] == "(immune" {
                (index, group.immunities) = parseTypes(index, tokens: tokens)
                if tokens[index] == "weak" {
                    (index, group.weaknesses) = parseTypes(index + 2, tokens: tokens)
                }
            } else if tokens[7] == "(weak" {
                (index, group.weaknesses) = parseTypes(index, tokens: tokens)
                if tokens[index] == "immune" {
                    (index, group.immunities) = parseTypes(index + 2, tokens: tokens)
                }
            } else {
                index = 7
            }
            group.attackType = tokens[index + 6]

            if parsingImmunityArmy {
                parsedImmunityArmy.append(group)
            } else {
                parsedInfectionArmy.append(group)
            }
        }
    }
    
    func parseTypes(_ startIndex: Int, tokens: [String]) -> (Int, [String]) {
        var index = startIndex
        var types: [String] = []
        var type = tokens[index]
        while type.last! == "," {
            types.append(String(type.dropLast()))
            index += 1
            type = tokens[index]
        }
        types.append(String(type.dropLast()))
        return (index + 1, types)
    }
    func error() {
        print("error!")
    }
}

class ArmyGroup : NSObject {
    var id = 0
    var isImmunity = true
    var units = 0
    var hitPointsPerUnit = 0
    var immunities:[String] = []
    var weaknesses:[String] = []
    var attackType = ""
    var damage = 0
    var initiative = 0
    var effectivePower: Int { get { return units * damage } }
    
    var target: ArmyGroup?
    var isTargeted = false
    
    func copy(boost: Int) -> ArmyGroup {
        let copy = ArmyGroup()
        copy.id = id
        copy.isImmunity = isImmunity
        copy.units = units
        copy.hitPointsPerUnit = hitPointsPerUnit
        copy.immunities = immunities
        copy.weaknesses = weaknesses
        copy.attackType = attackType
        copy.damage = damage + boost
        copy.initiative = initiative
        return copy
    }
    
    override var hash: Int  { get  { return isImmunity ? id : id << 32 }}
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? ArmyGroup else {
            return false
        }
        return self.isImmunity == other.isImmunity && self.id == other.id
    }
}
