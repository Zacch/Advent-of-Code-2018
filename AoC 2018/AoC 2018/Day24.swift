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
    // 22000 is too high

    func battle() -> [ArmyGroup] {
        while !immunityArmy.isEmpty && !infectionArmy.isEmpty {
            // Target selection
            var groupsInSelectOrder: [ArmyGroup] = []
            groupsInSelectOrder.append(contentsOf: immunityArmy)
            groupsInSelectOrder.append(contentsOf: infectionArmy)
            groupsInSelectOrder = groupsInSelectOrder.sorted { g1, g2 in
                return g1.effectivePower > g2.effectivePower ||
                    (g1.effectivePower == g2.effectivePower && g1.initiative > g2.initiative)
            }
            groupsInSelectOrder.forEach { $0.target = nil; $0.isTargeted = false }
            for attacker in groupsInSelectOrder {
                let enemies = attacker.isImmunity ? infectionArmy : immunityArmy
                
                if let target = enemies.filter({ !$0.isTargeted }).sorted(by: { g1, g2 in
                    let d1 = damage(by: attacker, on: g1)
                    let d2 = damage(by: attacker, on: g2)
                    print("\(attacker.isImmunity ? "Immune System" : "Infection") group \(attacker.id) would deal defending group \(g1.id) \(d1) damage")
                    print("\(attacker.isImmunity ? "Immune System" : "Infection") group \(attacker.id) would deal defending group \(g2.id) \(d2) damage")
                    return d1 > d2 ||
                        (d1 == d2 && g1.effectivePower > g2.effectivePower) ||
                        (d1 == d2 && g1.effectivePower == g2.effectivePower && g1.initiative > g2.initiative)
                }).first {
                    target.isTargeted = true
                    attacker.target = target
                }
            }
            print()
            // Attacking
            var groupsInAttackOrder: [ArmyGroup] = []
            groupsInAttackOrder.append(contentsOf: immunityArmy)
            groupsInAttackOrder.append(contentsOf: infectionArmy)
            groupsInAttackOrder = groupsInAttackOrder.sorted { $0.initiative > $1.initiative }
            
            for attacker in groupsInAttackOrder {
                if let target = attacker.target,
                    attacker.units > 0 {
                    let hit = damage(by: attacker, on: target)
                    let unitsLost = hit / target.hitPointsPerUnit
                    print("\(attacker.isImmunity ? "Immune System" : "Infection") group \(attacker.id) deals defending group \(target.id) \(hit) damage, killing \(unitsLost) units")
                    target.units -= unitsLost
                }
            }
            immunityArmy = immunityArmy.filter { $0.units > 0 }
            infectionArmy = infectionArmy.filter { $0.units > 0 }
            
            print("Immune System:")
            immunityArmy.forEach { print("Group \($0.id) contains \($0.units) units") }
            
            print("Infection:")
            infectionArmy.forEach { print("Group \($0.id) contains \($0.units) units") }
            print()
        }
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
            }

            if tokens[7] == "(weak" {
                (index, group.weaknesses) = parseTypes(index, tokens: tokens)
                if tokens[index] == "immune" {
                    (_, group.immunities) = parseTypes(index + 2, tokens: tokens)
                }
            }
            group.attackType = tokens[index + 6]

            if parsingImmunityArmy {
                immunityArmy.append(group)
            } else {
                infectionArmy.append(group)
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
    
    override public var description: String {
        return "\(isImmunity ? "Imm": "Inf") \(units) \(effectivePower) \(attackType) Immune to \(immunities) Weak to \(weaknesses) Targeted \(isTargeted)"
    }

}
