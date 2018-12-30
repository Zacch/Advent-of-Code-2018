//
//  Day24.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-24.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day24 {
    
    var immunityArmy: [ArmyGroup] = []
    var infectionArmy: [ArmyGroup] = []
    
    func solve () {
        parseInput()
        let winningArmy = battle()
        let units = winningArmy.map { $0.units }.reduce(0, +)
        print("Part1: \(units)")
        print("Part2: ")
    }

    func battle() -> [ArmyGroup] {
        while !immunityArmy.isEmpty && !infectionArmy.isEmpty {
            print("Immune System:")
            immunityArmy.forEach { print("Group \($0.id) contains \($0.units) units") }
            print("Infection:")
            infectionArmy.forEach { print("Group \($0.id) contains \($0.units) units") }
            print()

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
                filteredEnemies.forEach { target in
                    print("\(attacker.isImmunity ? "Immune System" : "Infection") group \(attacker.id) would deal defending group \(target.id) \(damage(by: attacker, on: target)) damage")
                }
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
            print()
            
            // Testing
            for group in immunityArmy {
                if group.isImmunity == false { error() }
                if group.units <= 0 { error() }
                if group.effectivePower <= 0 { error() }
                if infectionArmy.filter({ $0.target?.id == group.id }).count != (group.isTargeted ? 1 : 0) { error() }
            }
            for group in infectionArmy {
                if group.isImmunity == true { error() }
                if group.units <= 0 { error() }
                if group.effectivePower <= 0 { error() }
                if immunityArmy.filter({ $0.target?.id == group.id }).count != (group.isTargeted ? 1 : 0) { error() }
            }
            
            // Attacking
            var groupsInAttackOrder = Array(immunityArmy)
            groupsInAttackOrder.append(contentsOf: infectionArmy)
            groupsInAttackOrder = groupsInAttackOrder.sorted { $0.initiative > $1.initiative }
            
            for attacker in groupsInAttackOrder {
                if let target = attacker.target,
                   attacker.units > 0 {
                    let hit = damage(by: attacker, on: target)
                    let unitsLost = min(target.units, hit / target.hitPointsPerUnit)
                    print("\(attacker.isImmunity ? "Immune System" : "Infection") group \(attacker.id) attacks defending group \(target.id), killing \(unitsLost) \(unitsLost == 1 ? "unit" : "units")")
                    target.units -= unitsLost
                }
            }
            print()

            // Testing
            for group in immunityArmy {
                if group.isImmunity == false { error() }
                if group.units < 0 { error() }
                if group.effectivePower < 0 { error() }
                if infectionArmy.filter({ $0.target?.id == group.id }).count != (group.isTargeted ? 1 : 0) { error() }
            }
            for group in infectionArmy {
                if group.isImmunity == true { error() }
                if group.units < 0 { error() }
                if group.effectivePower < 0 { error() }
                if immunityArmy.filter({ $0.target?.id == group.id }).count != (group.isTargeted ? 1 : 0) { error() }
            }
            immunityArmy = immunityArmy.filter { $0.units > 0 }
            infectionArmy = infectionArmy.filter { $0.units > 0 }
        }
        
        print("Immune System:")
        if immunityArmy.isEmpty {
            print("No groups remain.")
        } else {
            immunityArmy.forEach { print("Group \($0.id) contains \($0.units) units") }
        }
        print("Infection:")
        if infectionArmy.isEmpty {
            print("No groups remain.")
        } else {
            infectionArmy.forEach { print("Group \($0.id) contains \($0.units) units") }
        }
        print()

        return immunityArmy.isEmpty ? infectionArmy : immunityArmy
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
                immunityArmy.append(group)
            } else {
                infectionArmy.append(group)
            }
        }
        print("Immune System:")
        immunityArmy.forEach { print($0) }
        print()
        print("Infection:")
        infectionArmy.forEach { print($0) }
        print()
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
    
    
    override var hash: Int  { get  { return isImmunity ? id : id << 32 }}
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? ArmyGroup else {
            return false
        }
        return self.isImmunity == other.isImmunity && self.id == other.id
    }

    /// A total overkill, aiming at producing the same output as in Day24.txt
    /// (but immunities and weaknesses are in random order in the text file)
    override public var description: String {
        var immuneString = ""
        if !immunities.isEmpty {
            immuneString = "immune to "
            immunities.forEach { immuneString += $0 + ", "}
            immuneString = String(immuneString.dropLast().dropLast())
        }

        var weaknessString = ""
        if !weaknesses.isEmpty {
            weaknessString = "weak to "
            weaknesses.forEach { weaknessString += $0 + ", "}
            weaknessString = String(weaknessString.dropLast().dropLast())
        }

        var totalString = ""
        if immuneString.isEmpty {
            totalString = weaknessString
        } else if weaknessString.isEmpty {
            totalString = immuneString
        } else {
            totalString = immuneString + "; " + weaknessString
        }
        if !totalString.isEmpty {
            totalString = "(" + totalString + ") "
        }
        return "\(units) units each with \(hitPointsPerUnit) hit points \(totalString)with an attack that does \(damage) \(attackType) damage at initiative \(initiative)"
    }
}
